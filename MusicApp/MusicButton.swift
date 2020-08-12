//
//  CircleButton.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/27/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class MusicButton: UIButton {
    
    // MARK: Variable
    private var _musicButtonState: MusicButtonState?
    var musicButtonState: MusicButtonState {
        get {
            return self._musicButtonState ?? MusicButtonState.play
        }
        set {
            self._musicButtonState = newValue
        }
    }
    
    let darkShadow = CALayer()
    let lightShadow = CALayer()

    // MARK: Override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.darkShadow.frame = self.bounds
        self.darkShadow.cornerRadius = self.bounds.width / 2
        self.darkShadow.backgroundColor = self.backgroundColor?.cgColor
        self.darkShadow.shadowColor = UIColor.black.cgColor
        self.darkShadow.shadowOffset = .init(width: -4, height: -4)
        self.darkShadow.shadowOpacity = 0.7
        self.darkShadow.shadowRadius = 5
        
        self.lightShadow.frame = self.bounds
        self.lightShadow.cornerRadius = self.bounds.width / 2
        self.lightShadow.backgroundColor = self.backgroundColor?.cgColor
        self.lightShadow.shadowColor = UIColor.white.cgColor
        self.lightShadow.shadowOffset = .init(width: 4, height: 4)
        self.lightShadow.shadowOpacity = 0.3
        self.lightShadow.shadowRadius = 5
        
        self.layer.insertSublayer(darkShadow, at: 0)
        self.layer.insertSublayer(lightShadow, at: 0)
    }
    
    // MARK: Function
    func setMusicButton(musicButtonState: MusicButtonState, imageEdgeInset: CGFloat = 15) {
        self.layer.cornerRadius = self.frame.width / 2
        self.imageEdgeInsets = .init(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)

        switch musicButtonState {
        case .play:
            self.musicButtonState = .play
            self.setImage(UIImage(named: "play-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        case .pause:
            self.musicButtonState = .pause
            self.setImage(UIImage(named: "pause-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color03
            self.tintColor = COLOR.color04
        case .prev:
            self.musicButtonState = .prev
            self.setImage(UIImage(named: "previous-icon")?.withRenderingMode(.automatic), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        case .next:
            self.musicButtonState = .next
            self.setImage(UIImage(named: "next-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        }
        
        self.neumorphicDesign()
        if let image = self.imageView {
            self.bringSubviewToFront(image)
        }
    }
    
    func neumorphicDesign() {
        self.darkShadow.frame = self.bounds
        self.darkShadow.cornerRadius = self.bounds.width / 2
        self.darkShadow.backgroundColor = self.backgroundColor?.cgColor
        self.darkShadow.shadowColor = UIColor.black.cgColor
        self.darkShadow.shadowOffset = .init(width: 4, height: 4)
        self.darkShadow.shadowOpacity = 0.3
        self.darkShadow.shadowRadius = 5
        
        self.lightShadow.frame = self.bounds
        self.lightShadow.cornerRadius = self.bounds.width / 2
        self.lightShadow.backgroundColor = self.backgroundColor?.cgColor
        self.lightShadow.shadowColor = UIColor.white.cgColor
        self.lightShadow.shadowOffset = .init(width: -4, height: -4)
        self.lightShadow.shadowOpacity = 0.7
        self.lightShadow.shadowRadius = 5
        
        self.layer.insertSublayer(darkShadow, at: 0)
        self.layer.insertSublayer(lightShadow, at: 0)
    }
}
