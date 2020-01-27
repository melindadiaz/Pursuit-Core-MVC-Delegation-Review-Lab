//
//  SettingsViewController.swift
//  MVC+Delegation-Review-Lab
//
//  Created by Melinda Diaz on 1/27/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit

//step 1: You need to put the function that will be used for you custom delegation PLUS you need parameters to AT LEAST SELF such as below
protocol SettingsViewControllerDelegate: AnyObject {
    func fontSizeDidChange(_ settingsViewController: SettingsViewController) // How you set up self parameters
}


class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var fontSizeOutlet: UILabel!
    //Step 2: set a weak var here to set custom delegation and IT MUST BE OPTIONAL
    weak var delegate: SettingsViewControllerDelegate?
    var allDetailedMovies = Movie.allMovies
    var fontSize = Float(17.0) {
        didSet{
            delegate?.fontSizeDidChange(self)
            sliderOutlet.value = fontSize
            stepperOutlet.value = Double(fontSize)
            //%0.f means to not have any placements
            fontSizeOutlet.text = "Font Size \(String(format: "%0.f", fontSize))"
            //step 3:PLACE THE FUNCTION IN THE PLACE THAT SIGNIFIES THE CHANGE
          
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daSetUp()
        navigationItem.title = "Movies"
    }
    
    func daSetUp() {
        stepperOutlet.maximumValue = 50.0
        sliderOutlet.maximumValue = 50.0
        stepperOutlet.minimumValue = 5.0
        sliderOutlet.minimumValue = 5.0
        stepperOutlet.value = Double(fontSize)
        sliderOutlet.value = fontSize
        
    }
    @IBAction func fontSizeChanger(_ sender: UISlider) {
        fontSize = sliderOutlet.value
    }
    
    @IBAction func fontSizeStepper(_ sender: UIStepper) {
        fontSize = Float(stepperOutlet.value)
    }
}

