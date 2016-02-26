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
    
    private init() {
        
    }
    
    func getCityWeather(city: String) {
        
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=\(apiKey)"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            let json = JSON(data: data!)
            let temp = json["main"]["temp"].double
            let tempMin = json["main"]["temp_min"].double
            let tempMax = json["main"]["temp_max"].double
            let name = json["name"].string
            let description = json["weather"][0]["description"].string!
            
            print("temp: \(temp!)")
            print("tempMin: \(tempMin!)")
            print("tempMax: \(tempMax!)")
            print("descripstion: \(description)")
            
            let weather = Weather(cityName: name!, currentTemp: temp!, minTemp: tempMin!, maxTemp: tempMax!, tempDescription: description)
            self.weatherList.append(weather)
            
            //if self.delegate != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)
                })
           // }
            
        }
        task.resume()
    }
    
}