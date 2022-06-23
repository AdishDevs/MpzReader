//
//  File.swift
//  MpzReader
//
//  Created by Hasitha Mapalagama on 8/17/19.
//

import Foundation
import UIKit
import R2Navigator
import R2Shared
class MpzSettingsVC : UITableViewController {
    
    static func create(withDelegate delegate : MpzBookViewSettingsDelegate) -> MpzSettingsVC {
        let stry = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: MpzSettingsVC.self))
        let vc = stry.instantiateViewController(withIdentifier: "settings_vc") as! MpzSettingsVC
        vc.delegate = delegate
        vc.preferredContentSize = CGSize.init(width: 270, height: 263)
        return vc
    }
    
    var delegate : MpzBookViewSettingsDelegate?
    
    @IBOutlet weak var vertical: UIView!
    @IBOutlet weak var horizontal: UIView!
    @IBOutlet weak var dark: UIView!
    @IBOutlet weak var light: UIView!
    @IBOutlet weak var brightness: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFontSize()
        self.setModeUI()
        self.setScrollModeUI()
    }
    @IBAction func didClickMinusFontSize(_ sender: Any) {
        self.changeFontSize(increment: false)
    }
    
    @IBAction func didClickPlusFontSize(_ sender: Any) {
        self.changeFontSize(increment: true)
    }
    
    @IBAction func didClickLightMode(_ sender: Any) {
        self.changeMode(isNight: false)
    }
    
    @IBAction func didClickDarkMode(_ sender: Any) {
        self.changeMode(isNight: true)
    }
    
    @IBAction func didClickHorizontal(_ sender: Any) {
        self.changeScrollMode(isVertical: false)
    }
    
    @IBAction func didClickVertical(_ sender: Any) {
        self.changeScrollMode(isVertical: true)
    }
   
    @IBAction func didBrightnessChanged(_ sender: Any) {
        UIScreen.main.brightness = CGFloat(brightness.value)
    }
    
    
    
    private func setupFontSize() {
        if let currentFontSize = delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.fontSize.rawValue) as? Incrementable {
            currentFontSize.max = 250.0
            currentFontSize.min = 75.0
            currentFontSize.step = 12.5
        }
    }
    
    private func setModeUI() {
        if let appearance = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.appearance.rawValue) as? Enumerable {
            if appearance.index == 2 {
                light.alpha = 0.5
                dark.alpha = 1
            }else{
                light.alpha = 1
                dark.alpha = 0.5
            }
        }
    }
    
    private func setScrollModeUI() {
        if let scroll = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.scroll.rawValue) as? Switchable {
            if scroll.on {
                vertical.alpha = 1
                horizontal.alpha = 0.5
            }else{
                vertical.alpha = 0.5
                horizontal.alpha = 1
            }
        }
    }
}

extension MpzSettingsVC {
    
    func changeFontSize(increment : Bool) {
        if let fontSize = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.fontSize.rawValue) as? Incrementable {
            print("change font size is increment", increment)
            if increment {
                fontSize.increment()
            }else{
                fontSize.decrement()
            }
            self.delegate?.updateUserSettings()
        }
    }
    
    func changeMode(isNight : Bool) {
        if let appearance = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.appearance.rawValue) as? Enumerable {
            print("change mode isNight", isNight)
            appearance.index = isNight ? 2 : 0
            self.delegate?.updateUserSettings()
            self.delegate?.updateReaderColors()
            self.setModeUI()
        }
    }
    
    
    func changeScrollMode(isVertical : Bool) {
        if let scroll = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.scroll.rawValue) as? Switchable {
            print("change scroll mode isVertical", isVertical)
            scroll.on = isVertical
            self.delegate?.updateUserSettings()
            self.setScrollModeUI()
        }
    }
    
}
