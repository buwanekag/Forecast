//
//  DataManager.swift
//  Forecast
//
//  Created by Buwaneka Galpoththawela on 11/3/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit
import CoreLocation

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    var baseURLString = "api.forecast.io"
    var currentForecast = Forecast()
    
    
    //MARK: - MAP
    
    func convertCoordinateToString(coordinate: CLLocationCoordinate2D) -> String {
        print("\(coordinate.latitude),\(coordinate.longitude)")
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {
            (placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates = placemark.location!.coordinate
                self.getDataFromServer(self.convertCoordinateToString(coordinates))
                
            }
        })
    }
    
    
    
    
    //MARK: - GET DATA METHOD
    
    func parseForecastData(data:NSData){
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            //print("JSON:\(jsonResult)")
            
            let tempDict = jsonResult.objectForKey("currently") as! NSDictionary
            self.currentForecast.temperature = String(tempDict.objectForKey("temperature")!)
            self.currentForecast.humidity = String(tempDict.objectForKey("humidity")!)
            self.currentForecast.summary = String(tempDict.objectForKey("summary")!)
            self.currentForecast.cloudCover = String(tempDict.objectForKey("cloudCover")!)
            self.currentForecast.icon = String(tempDict.objectForKey("icon")!)
            self.currentForecast.windSpeed = String(tempDict.objectForKey("windSpeed")!)
            self.currentForecast.time = String(tempDict.objectForKey("time")!)
            self.currentForecast.dewPoint = String(tempDict.objectForKey("dewPoint")!)
           
            
            //self.currentForecast.Visibility = String(tempDict.objectForKey("visibility")!)
           // self.currentForecast.pressure = String(tempDict.objectForKey("pressure")!)
            
           
            
            print("Temp:\(self.currentForecast.temperature)")
            
           
           
            
            
            dispatch_async(dispatch_get_main_queue()){
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedDataFromServer", object: nil))
            }

        
            
        } catch {
            print("Json error")
        }
        
    }
    
    
    
    func getDataFromServer(searchString: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        let url = NSURL(string: "https://\(baseURLString)/forecast/0609bccb6561189c51860d3fda20313f/\(searchString)")

        let urlRequest = NSURLRequest(URL: url!,cachePolicy: .ReloadIgnoringLocalCacheData,timeoutInterval:30.0)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest){ (data, response,error) ->  Void in
            if data != nil {
                print("got data")
                self.parseForecastData(data!)
            }else {
                print("No Data")
            }
            
            
        }
        task.resume()
        
    }
    

}
