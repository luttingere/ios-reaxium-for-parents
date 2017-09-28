//
//  CoreDataManager.swift
//  ReaxiumForParents
//
//  Created by Freddy Miguel Vega Zárate on 27-05-17.
//  Copyright © 2017 Jorge Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private var managedObjectContext: NSManagedObjectContext
    
    static let shared: CoreDataManager = {
        let instance = CoreDataManager()
        
        return instance
    }()
    
    private init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Reaxium", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Reaxium.sqlite")
        
        // Add core data light weight migrations
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func save(notification: AccessNotification) {
        let components = ReaxiumHelper.getComponentsFrom(date: notification.date!)
        let entity = NSEntityDescription.insertNewObject(forEntityName: "NotificationEntity", into: managedObjectContext)
        
        entity.setValue(notification.message, forKey: "access_info")
        entity.setValue(notification.ID, forKey: "access_type")
        entity.setValue(notification.date, forKey: "date")
        entity.setValue(false, forKey: "readed")
        entity.setValue(notification.studentID, forKey: "student_id")
        entity.setValue(components.day, forKey: "day")
        entity.setValue(components.month, forKey: "month")
        entity.setValue(components.year, forKey: "year")
        
        // we save our entity
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func load(_ studentId: String) -> [NotificationEntity]? {
        var results: [NotificationEntity]? = nil

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationEntity")
        request.predicate = NSPredicate(format: "student_id == %@", studentId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            results = try managedObjectContext.fetch(request) as? [NotificationEntity]
        } catch {
            print("Couldn't fetch results")
            return [NotificationEntity]()
        }
        
        return results
    }
    
    func groupByDayMonthYear(_ studentId: String) -> Array<Dictionary<String, Int32>>? {
        var results: Array<Dictionary<String, Int32>>? = nil
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationEntity")
        
        let dayExpr = NSExpression(forKeyPath: "day")
        let countExpr = NSExpressionDescription()
        
        countExpr.name = "count"
        countExpr.expression = NSExpression(forFunction: "count:", arguments: [dayExpr])
        countExpr.expressionResultType = .integer32AttributeType
        
        request.returnsObjectsAsFaults = false
        request.resultType = .dictionaryResultType
        request.propertiesToGroupBy = ["day", "month", "year"]
        request.propertiesToFetch = ["day", "month", "year", countExpr]
        request.predicate = NSPredicate(format: "student_id == %@", studentId)
        request.sortDescriptors = [NSSortDescriptor(key: "day", ascending: false), NSSortDescriptor(key: "month", ascending: false), NSSortDescriptor(key: "year", ascending: false)]
        
        do {
            results = try managedObjectContext.fetch(request) as? Array<Dictionary<String, Int32>>
        } catch {
            print("Couldn't fetch results")
            return Array()
        }
        
        return results
    }
    
    func loadUnreaded(_ studentId: String) -> [NotificationEntity]? {
        var results: [NotificationEntity]? = nil
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationEntity")
        request.predicate = NSPredicate(format: "student_id == %@ AND readed == %@", studentId, NSNumber(booleanLiteral: false))
        request.returnsObjectsAsFaults = false
        
        do {
            results = try managedObjectContext.fetch(request) as? [NotificationEntity]
        } catch {
            print("Couldn't fetch results")
            return [NotificationEntity]()
        }
        
        return results
    }
    
    func countUnreaded(_ studentId: String) -> Int {
        let entities = loadUnreaded(studentId)
        return (entities?.count)!
    }
    
    func markAsReaded(_ studentId: String) {
        let entities = loadUnreaded(studentId)
        
        for entity in entities! {
            entity.readed = true
        }
        
        if (entities?.count)! > 0 {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func delete(_ studentId: String) {
        let entities = load(studentId)
        
        for entity in entities! {
            managedObjectContext.delete(entity)
        }
        
        if (entities?.count)! > 0 {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
