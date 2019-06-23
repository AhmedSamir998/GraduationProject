//
//  PrayerTimesTableViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import CoreLocation

class PrayerTimesTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet var prayerTimesTableView: UITableView!
    @IBOutlet weak var fajrTimeLabel: UILabel!
    @IBOutlet weak var sunshineTimeLabel: UILabel!
    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var asrTimeLabel: UILabel!
    @IBOutlet weak var maghribTimeLabel: UILabel!
    @IBOutlet weak var ishaTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        showAlertControllerWithTextField()

        performUIUpdatesOnMain {
            self.prayerTimesTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func showAlertControllerWithTextField() {
        let alertController = UIAlertController(title: "Enter your City in English", message: "Please, enter your city in English to get it's pray times. You can cancel this step and we will use your location to send pray times. But it may be not accurate.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let cityTextField = alertController.textFields![0] as UITextField
            if cityTextField.text != "" {
                UserDefaults.standard.set(cityTextField.text, forKey: "userCity")
                self.fetchPrayTimesFromApiUsingCity(city: UserDefaults.standard.string(forKey: "userCity")!)
                
            } else {
                self.fetchPrayTimesFromApiUsingLocation(long: self.locationManager.location!.coordinate.longitude, lat: self.locationManager.location!.coordinate.latitude, elevation: self.locationManager.location!.altitude)
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Your City in English"
            textField.text = UserDefaults.standard.string(forKey: "userCity") ?? ""
        }
        
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.fetchPrayTimesFromApiUsingLocation(long: self.locationManager.location!.coordinate.longitude, lat: self.locationManager.location!.coordinate.latitude, elevation: self.locationManager.location!.altitude)
        }
            alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchPrayTimesFromApiUsingLocation(long: Double, lat: Double, elevation: Double) {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
        Client.shared().getDataFromURLUsingLocation(longitude: long, latitude: lat, elevation: elevation, completionHandler: {(dateTimeData, error) in
            
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Pray times", withMessage: "We didn't find any Information, Be sure to be connected with Internet or try again later.")
                
            }
            
            else if let timeData = dateTimeData {
                self.performUIUpdatesOnMain {
                    self.updateUILabelsWithData(locationTimeData: timeData)
                }
            }
        })
    }
    
    func fetchPrayTimesFromApiUsingCity(city: String) {
        activityIndicator.startAnimating()
        Client.shared().getDataFromURLUsingCity(city: city, completionHandler: {(cityDateTimeData, error) in
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Pray times", withMessage: "We didn't find any Information. It may be no Internet Connection or You may enterd wrong City Name. We will use your location to get Pray Times.")
                
                self.fetchPrayTimesFromApiUsingLocation(long: self.locationManager.location!.coordinate.longitude, lat: self.locationManager.location!.coordinate.latitude, elevation: self.locationManager.location!.altitude)
            }
                
            else if let timeData = cityDateTimeData {
                self.performUIUpdatesOnMain {
                    self.updateUILabelsWithData(cityTimeData: timeData)
                }
            }

        })
    }
    
    fileprivate func updateUILabelsWithData(cityTimeData: CityDateTimeData? = nil, locationTimeData: DateTimeData? = nil) {
        if (cityTimeData != nil) {
            self.fajrTimeLabel.text = cityTimeData?.times.Fajr
            self.sunshineTimeLabel.text = cityTimeData?.times.Sunrise
            self.dhuhrTimeLabel.text = cityTimeData?.times.Dhuhr
            self.asrTimeLabel.text = cityTimeData?.times.Asr
            self.maghribTimeLabel.text = cityTimeData?.times.Maghrib
            self.ishaTimeLabel.text = cityTimeData?.times.Isha
        }
        else if (locationTimeData != nil) {
            self.fajrTimeLabel.text = locationTimeData?.times.Fajr
            self.sunshineTimeLabel.text = locationTimeData?.times.Sunrise
            self.dhuhrTimeLabel.text = locationTimeData?.times.Dhuhr
            self.asrTimeLabel.text = locationTimeData?.times.Asr
            self.maghribTimeLabel.text = locationTimeData?.times.Maghrib
            self.ishaTimeLabel.text = locationTimeData?.times.Isha
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        print(currentLocation!)
    }

}
