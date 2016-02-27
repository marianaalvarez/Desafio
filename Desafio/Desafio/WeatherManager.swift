//
//  WeatherManager.swift
//  Desafio
//
//  Created by Mariana Alvarez on 25/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import Foundation

class WeatherManager {
    
    static let sharedInstance = WeatherManager()
    let apiKey = "d8db38a6094a896d458a8ed6108ad51d"
    
    var weatherList = [Weather]()
    var weatherListSort = [Weather]()
    
    private init() {
        
    }
    
    func getCities(left: String, bottom: String, right: String, top: String) {
        
        let path = "http://api.openweathermap.org/data/2.5/box/city?bbox=\(left),\(bottom),\(right),\(top),100&appid=\(apiKey)"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error != nil {
                print("erro")
            }
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            self.weatherList.removeAll()
            self.weatherListSort.removeAll()
            
            NSNotificationCenter.defaultCenter().postNotificationName("removeAnnotations", object: self)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let list = json["list"] as? [[String: AnyObject]] {
                    
                    for item in list {
                        let weather = Weather()
                        
                        weather.city = item["name"] as? String
                        weather.temp = item["main"]!["temp"] as? Double
                        weather.tempMin = item["main"]!["temp_min"] as? Double
                        weather.tempMax = item["main"]!["temp_max"] as? Double
                        weather.tempDescription = item["weather"]![0]["description"] as? String
                        weather.latitude = item["coord"]!["lat"] as? Double
                        weather.longitude = item["coord"]!["lon"] as? Double
                        
                        self.weatherList.append(weather)
                        
                        let userInfo = ["weather": weather]
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName("addAnnotation", object: self,userInfo: userInfo)
                            
                        })
                    }
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
}