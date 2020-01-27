//
//  SettingsViewController.swift
//  MVC+Delegation-Review-Lab
//
//  Created by Melinda Diaz on 1/27/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit
//TODO: finish custom delegation

protocol SettingsViewControllerDelegate: AnyObject {
    func daSetUP() //is this the correct function needed or is it something else
}


class SettingsViewController: UIViewController {

    
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var fontSizeOutlet: UILabel!
    
    var allDetailedMovies = Movie.allMovies
    var fontSize = Float(17.0) {
    didSet{
        sliderOutlet.value = fontSize
        stepperOutlet.value = Double(fontSize)
        //%0.f means to not have any placements
        fontSizeOutlet.text = "Font Size \(String(format: "%0.f", fontSize))"
        //reload the tableView tableView.reloadData()
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       daSetUp()
        
    }
    
    func daSetUp() {
            stepperOutlet.maximumValue = 50.0
               sliderOutlet.maximumValue = 50.0
               stepperOutlet.minimumValue = 5.0
               sliderOutlet.minimumValue = 5.0
                
    }
    @IBAction func fontSizeChanger(_ sender: UISlider) {
        fontSize = sliderOutlet.value
    }

    @IBAction func fontSizeStepper(_ sender: UIStepper) {
        fontSize = Float(stepperOutlet.value)
    }
}

