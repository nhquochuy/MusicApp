//
//  NeumorphisDesignVIew.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/30/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class NeumorphisDesignVIew: UIView {

    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        
        self.beNeumorphicDesign()
    }
    
    func beNeumorphicDesign() {
        self.layer.masksToBounds = false
        let darkShadow = CALayer()
        let lightShadow = CALayer() 
        darkShadow.frame = self.bounds
        darkShadow.cornerRadius = self.bounds.width / 2
        darkShadow.backgroundColor = self.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        darkShadow.shadowOffset = .init(width: 7, height: 7)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = 5
        
        lightShadow.frame = self.bounds
        lightShadow.cornerRadius = self.bounds.width / 2
        lightShadow.backgroundColor = self.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.withAlphaComponent(0.5).cgColor
        lightShadow.shadowOffset = .init(width: -3, height: -3)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = 5
        
        self.layer.insertSublayer(darkShadow, at: 0)
        self.layer.insertSublayer(lightShadow, at: 0)
    }
}
