//
//  TableViewController.swift
//  Desafio
//
//  Created by Mariana Alvarez on 24/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var manager = WeatherManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getCityWeather("São Paulo")
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didGetCity"), name: "reloadData", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.weatherList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Card", forIndexPath: indexPath) as! CardTableViewCell
        
        let weather = WeatherManager.sharedInstance.weatherList[indexPath.row] as Weather
        
        cell.cityLabel.text = weather.cityName
        cell.iconImageView.image = UIImage(named: "map")
        cell.skyLabel.text = weather.tempDescription
        cell.minLabel.text = String(weather.minTemp)
        cell.maxLabel.text = String(weather.maxTemp)
        cell.temperatureLabel.text = String(weather.currentTemp)
        cell.cardView.layer.cornerRadius = 10
        cell.cardView.layer.masksToBounds = true
        
        return cell
        
    }
    
    func didGetCity() {
        self.tableView.reloadData()
    }

}
