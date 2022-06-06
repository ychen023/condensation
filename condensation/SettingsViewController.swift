//
//  SettingsViewController.swift
//  condensation
//
//  Created by Ian Wang on 5/24/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var darkModeSlider: UISwitch!
    @IBOutlet weak var minRatingDisplay: UILabel!
    @IBOutlet weak var minRatingSlider: UISlider!
    @IBOutlet weak var releaseDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        
        darkModeSlider.isOn = userDefaults.bool(forKey: "darkMode")
        
        let earliestRelease = userDefaults.string(forKey: "earliestRelease")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yy"
        print(earliestRelease)
        let date = dateFormatter.date(from: earliestRelease)!
        releaseDatePicker.setDate(date, animated: true)
        
        let minRating = Float(userDefaults.string(forKey: "minRating")!)!
        
        minRatingSlider.setValue(minRating, animated: true)
        minRatingDisplay.text = String(Int(minRating))
    }
    
    @IBAction func ratingSliderChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        minRatingDisplay.text = String(currentValue)
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(String(currentValue), forKey: "minRating")
    }
    
    @IBAction func releaseDateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: releaseDatePicker.date)
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(strDate, forKey: "earliestRelease")
        
        print(strDate)
    }
    
    @IBAction func darkModeToggled(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(darkModeSlider.isOn, forKey: "darkMode")
        
        UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = userDefaults.bool(forKey: "darkMode") ? .dark : .light
    }
}
