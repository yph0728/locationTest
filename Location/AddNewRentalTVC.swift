//
//  AddNewRentalTVC.swift
//  Location
//
//  Created by Andrew Lau on 26/09/2015.
//  Copyright © 2015 SouthPark. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddNewRentalTVC: UITableViewController, CLLocationManagerDelegate{
   
    var locationManager  : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        //ForNavigation is the best
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "localeChanged:", name: NSCurrentLocaleDidChangeNotification, object: nil)
        
    }

    
    func localeChanged(notification : NSNotification){
        self.tableView.reloadData()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func userCurrentLocation() {
        // Ask for Authorisation from the User.

        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled");
        }
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
        {
            print("now we are able to access the location data")
           
        }
   
    }
    
    @IBOutlet weak var locationTxt: UITextField!
    
    
    var currentLocation = CLLocation()
    var currentLocationTxt :String?
 
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let _ = manager.location{
           
            currentLocation = manager.location!
            print("locations =  \(currentLocation.coordinate.latitude)  \(currentLocation.coordinate.longitude)")
            
            let location = locations[0] as CLLocation
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error)  in
                if let _ = error{ print(error)  }
                else if let validPlacemark = placemarks?[0]{
                    
                    let placemark = validPlacemark as CLPlacemark;
                    var address = ""
                    if let _ = placemark.subThoroughfare{
                        address += "\(placemark.subThoroughfare!) "
                    }
                    if let _ = placemark.thoroughfare{
                        address +=  "\(placemark.thoroughfare!) "
                    }
                    if let _ = placemark.administrativeArea{
                        address +=  "\(placemark.administrativeArea!) "
                    }
                    if let _ = placemark.locality{
                        address +=  "\(placemark.locality!) "
                    }
                    if let _ = placemark.country{
                        address +=  "\( placemark.country!) "
                    }
                    

                    
                    self.currentLocationTxt = address
                    print("set")
                
                }
                
            })

        }
 
        if let _ = currentLocationTxt{
            
                self.locationTxt.text = self.currentLocationTxt
                print("setTxt")
                locationManager.stopUpdatingLocation()
            
        }
        else{ print("nothing") }

    }

    
    
    
    @IBOutlet var pickerView: UIDatePicker!

    
    
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
