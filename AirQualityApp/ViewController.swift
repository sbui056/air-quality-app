//
//  ViewController.swift
//  AirQualityApp
//
//  Created by Steven Bui on 3/15/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getAirQuality(_ sender: Any) {
        fetchAirQuality()
    }
    
    func fetchAirQuality() {
        // get components for API call
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                print("API Key not found in .env file")
                return
            }
        let city = "Los Angeles"
        let state = "California"
        let country = "USA"
        
        let urlString = "https://api.airvisual.com/v2/city?city=\(city)&state=\(state)&country=\(country)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Incorrect Website")
            return
        }
        
        // Make API Call
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            print("Data: \(data)")
//            print("Response: \(response)")
//            print("Error: \(error)")
            
            // Parse API response
            guard let responseData = data else {
                // Let the user know that there is no data
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let dataFromJson = json["data"] as? [String: Any],
                   let currentFromJson = dataFromJson["current"] as? [String: Any],
                   let pollutionFromJson = currentFromJson["pollution"] as? [String: Any],
                   let aqius = pollutionFromJson["aqius"] as? Int
                {
                    DispatchQueue.main.async {
                        self.showImageForAqiusValue(aqius)
                    }
                }
            } catch {
                // Let the user know that there is no data
                print("Error getting json")
            }
        }
        
        task.resume()
        
        // Show the right image
    }
    
    func showImageForAqiusValue(_ value: Int) { // gloomy happy meh thursday
        if (value <= 50) {
            // show GOOD image
            myImageView.image = UIImage(named: "happy")
        } else if (value <= 150) {
            // show OKAY image
            myImageView.image = UIImage(named: "meh")
            
        } else {
            // show BAD air quality image
            myImageView.image = UIImage(named: "gloomy")
            
        }
    }
}

