//
//  Weather.swift
//  Desafio
//
//  Created by Mariana Alvarez on 25/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import Foundation

class Weather: NSObject {
    
    var city: String!
    var temp: Double!
    var tempMin: Double!
    var tempMax: Double!
    var tempDescription: String!
    var icon: String!
    var latitude: Double!
    var longitude: Double!
    
    override init() {
    }
    
    init(city: String, temp: Double, tempMin: Double, tempMax: Double, description: String, icon: String, lat: Double, lon: Double) {
        self.city = city
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.tempDescription = description
        self.icon = icon
        self.latitude = lat
        self.longitude = lon
    }

}