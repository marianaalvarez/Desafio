//
//  ViewController.swift
//  Desafio
//
//  Created by Mariana Alvarez on 24/02/16.
//  Copyright © 2016 Mariana Alvarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - VARIABLES

    var list: Bool!
    var celsius: Bool!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var modeButton: UIBarButtonItem!
    @IBOutlet weak var temperatureButton: UIBarButtonItem!
    
    
    // MARK: - VIEW
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.temperatureButton.title = "ºC"
        
        self.list = true
        self.celsius = true
        self.setListMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CONTROLLER
    
    @IBAction func modeButtonClicked(sender: AnyObject) {
        self.list = !self.list
        if self.list == true {
            self.setListMode()
        } else {
            self.setMapMode()
        }
    }
    
    @IBAction func temperatureButtonClicked(sender: AnyObject) {
        self.celsius = !self.celsius
        if self.celsius == true {
            self.temperatureButton.title = "ºC"
        } else {
            self.temperatureButton.title = "ºF"
        }
    }
    
    func setListMode() {
        self.modeButton.title = "Mapa"
        self.listView.hidden = false
        self.mapView.hidden = true
        
    }
    
    func setMapMode() {
        self.modeButton.title = "Lista"
        self.listView.hidden = true
        self.mapView.hidden = false
    }

}

