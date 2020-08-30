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
    var musicButtonState = MusicButtonState.play
    
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    

    // MARK: Override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
    }

    // MARK: Function
    func setMusicButton(musicButtonState: MusicButtonState, imageEdgeInset: CGFloat = 15) {
        self.layer.cornerRadius = self.frame.width / 2
        self.imageEdgeInsets = .init(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)

        switch musicButtonState {
        case .play:
            self.musicButtonState = .play
            self.setImage(UIImage(named: "play-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = .color05
            self.tintColor = .color06
        case .pause:
            self.musicButtonState = .pause
            self.setImage(UIImage(named: "pause-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = .color03
            self.tintColor = .color04
        case .prev:
            self.musicButtonState = .prev
            self.setImage(UIImage(named: "previous-icon")?.withRenderingMode(.automatic), for: .normal)
            self.backgroundColor = .color05
            self.tintColor = .color06
        case .next:
            self.musicButtonState = .next
            self.setImage(UIImage(named: "next-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = .color05
            self.tintColor = .color06
        }
    }
}
