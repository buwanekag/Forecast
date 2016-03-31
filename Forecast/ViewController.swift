//
//  ViewController.swift
//  Forecast
//
//  Created by Buwaneka Galpoththawela on 11/3/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate {
    
    
  
    
    
    var networkManager = NetworkManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    
    let locManager = CLLocationManager()
    
    @IBOutlet weak var seachText :UISearchBar!
    @IBOutlet weak var tempratureLabel :UILabel!
    @IBOutlet weak var summaryLabel :UILabel!
    @IBOutlet weak var weatherImage :UIImageView!
    @IBOutlet weak var locationDisplay : UILabel!
    @IBOutlet weak var windDisplay : UILabel!
    @IBOutlet weak var  windLabel :UILabel!
    @IBOutlet weak var  humidityDisplay :UILabel!
    @IBOutlet weak var  humidityLabel :UILabel!
    @IBOutlet weak var detailsView :UIView!
    @IBOutlet weak var cloudCover :UILabel!
    @IBOutlet weak var cloudCoverValue :UILabel!
    @IBOutlet weak var visibilityValue :UILabel!
    @IBOutlet weak var pressureValue : UILabel!
    @IBOutlet weak var dewPointValue : UILabel!
   
    
    
 
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if networkManager.serverAvailable {
            
            if seachText.text?.characters.count > 0 {
                searchBar.resignFirstResponder()
                dataManager.geocodeAddress(seachText.text!)
                locationDisplay.text = seachText.text
                windLabel.hidden = false
                humidityLabel.hidden = false
                cloudCover.hidden = false
                seachText.text = ""
                detailsView.hidden = false
            
            
                
            }
            
        }else {
            print("server not available")
        }

    }
    
    
    

    

    
    
    func newDataReceived(){
       let displayForecast = dataManager.currentForecast
        let formatedTemp = String (format: "%.0f",Double(displayForecast.temperature)!)
        tempratureLabel.text! = "\(formatedTemp)°"
        summaryLabel.text = displayForecast.summary
       
        let formatedWind = String(format:"%.0f",Double(displayForecast.windSpeed)!)
        windDisplay.text =  "\(formatedWind)MPH"
    
        let formatedHumidity = String(format:"%.0f",Double(displayForecast.humidity)!*100)
        humidityDisplay.text = "\(formatedHumidity)%"
     
        
        let formatedCoudCoover = String(format:"%.0f",Double(displayForecast.cloudCover)!*100)
        cloudCoverValue.text = "\(formatedCoudCoover)%"
       


        
        switch displayForecast.icon {
            
        case "clear-day":
            weatherImage.image = UIImage(named: "Sunny")
            
        case "clear-night":
            weatherImage.image = UIImage(named: "Night")
            
        case "partly-cloudy-day":
            weatherImage.image = UIImage(named: "Cloudy")
            
        case "wind":
            weatherImage.image = UIImage(named: "Windy")
            
        case "partly-cloudy-night":
            weatherImage.image = UIImage(named: "Night")
            
        case "cloudy":
            weatherImage.image = UIImage(named: "Cloudy")
            
        case "fog":
            weatherImage.image = UIImage(named: "Fog")
            
        case "rain":
            weatherImage.image = UIImage(named: "Rain")
            
        case "sleet":
            weatherImage.image = UIImage(named: "Sleet")
            
        case "snow":
            weatherImage.image = UIImage(named: "Snow")
            
        default:
            weatherImage.image = nil
        }
        
        print("got it")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        windLabel.hidden = true
        humidityLabel.hidden = true
    
        view.backgroundColor = UIColor.seaBlue()
       
        
        detailsView.backgroundColor = UIColor.seaBlue()
        detailsView.hidden = true
       
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataReceived", name: "receivedDataFromServer", object: nil)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}

