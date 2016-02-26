//
//  Weather.swift
//  Desafio
//
//  Created by Mariana Alvarez on 25/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import Foundation

class Weather: NSObject {
    
    var cityName: String!
    var currentTemp: Double!
    var minTemp: Double!
    var maxTemp: Double!
    var tempDescription: String!
    
    init(cityName: String, currentTemp: Double, minTemp: Double, maxTemp: Double, tempDescription: String) {
        self.cityName = cityName
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.tempDescription = tempDescription
    }

}