//
//  TrackStudentViewController.swift
//  ReaxiumForParents
//
//  Created by Jorge Rodriguez on 2/6/16.
//  Copyright © 2016 Jorge Rodriguez. All rights reserved.
//

import UIKit
import GoogleMaps
import KSToastView

class TrackStudentViewController: UIViewController {

    var camera:GMSCameraPosition!
    var mapView:GMSMapView!
    var marker:GMSMarker!
    var updateTimer: NSTimer!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var loadingView: UIView = UIView()
    var locationUpdate = LocationUpdateWebService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lat = CLLocationDegrees.init(-33.86)
        let lng = CLLocationDegrees.init(151.20)

        camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lng, zoom: 16)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        updateMarkerPositionWithCoordinates(-33.86, longitude: 151.20)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(requestChildrenLocationUpdate), userInfo: nil, repeats: true)

    }
    
    override func viewWillDisappear(animated: Bool) {
        updateTimer.invalidate()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestChildrenLocationUpdate() -> Void {
        showActivityIndicator()
        let parameters = ["ReaxiumParameters":
            ["DeviceUpdateLocation":
                ["user_in_track_id":"121",
                    "user_stakeholder_id":"40",
                    "device_token":GlobalVariable.deviceToken,
                    "device_platform":GlobalConstants.devicePlatform]
            ]
        ]

        locationUpdate.callServiceObject(parameters) { (result, error) in
            if error == nil{
                if let location = result as? LocationNotification{
                    self.updateMarkerPositionWithCoordinates(Float(location.latitude)!, longitude:Float(location.longitude)!)
                }
            }
            else{
                KSToastView.ks_showToast(error?.localizedDescription, duration: 3.0)
            }
            self.hideActivityIndicator()
        }
    }
    
    func updateMarkerPositionWithCoordinates(latitude:Float, longitude:Float){
        
        let lat = CLLocationDegrees.init(latitude)
        let lng = CLLocationDegrees.init(longitude)
        
        mapView.clear()

        marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        marker.icon = UIImage(named:"app_icon")
        marker.map = mapView
        
        mapView.animateToLocation(marker.position)
        
        
    }
    
    func showActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor.blackColor()
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
