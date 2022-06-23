//
//  SettingsView.swift
//  MpzReader
//
//  Created by Hasitha Mapalagama on 9/2/20.
//

import Foundation
import Foundation
import UIKit
import R2Navigator
import R2Shared
class SettingsView : UIView {
    var view : UIView!
    
    @IBOutlet weak var innerContainer: UIView!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    var clickHide : (() -> ())?
    var delegate : MpzBookViewSettingsDelegate?
    
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var vertical: UIView!
    @IBOutlet weak var horizontal: UIView!
    @IBOutlet weak var dark: UIView!
    @IBOutlet weak var light: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.init(for: type(of: self)))
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.view.frame = bounds
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(self.view)
        
     
    }

    func prepare() {
        setupFontSize()
             setModeUI()
             setScrollModeUI()
    }
    
    @IBAction func didClickOutside(_ sender: Any) {
        self.clickHide?()
    }
    
    
    private func setupFontSize() {
          if let currentFontSize = delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.fontSize.rawValue) as? Incrementable {
            currentFontSize.max = 200.0
              currentFontSize.min = 80.0
              currentFontSize.step = 20
            self.fontSlider.maximumValue = 200.0
            self.fontSlider.minimumValue = 80.0
            self.fontSlider.value = currentFontSize.value
          }
      }
      
      private func setModeUI() {
          if let appearance = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.appearance.rawValue) as? Enumerable {
              if appearance.index == 2 {
                  light.alpha = 0.3
                  dark.alpha = 1
              }else{
                  light.alpha = 1
                  dark.alpha = 0.3
              }
          }
      }
      
      private func setScrollModeUI() {
          if let scroll = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.scroll.rawValue) as? Switchable {
              if scroll.on {
                  vertical.alpha = 1
                  horizontal.alpha = 0.3
              }else{
                  vertical.alpha = 0.3
                  horizontal.alpha = 1
              }
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
    
    @IBAction func didChangeValue(_ sender: Any) {
       if let fontSize = self.delegate?.getUserSettings().userProperties.getProperty(reference: ReadiumCSSReference.fontSize.rawValue) as? Incrementable {
            fontSize.value = self.fontSlider.value
            self.delegate?.updateUserSettings()
        }
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
    
    
}

