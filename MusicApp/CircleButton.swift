//
//  CircleButton.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/27/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class MusicButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    // MARK: Variable
    private var _musicState: TypeMusicButton?
    public var test: String = "aaaa"
    var musicState: TypeMusicButton {
        get {
            return self._musicState ?? TypeMusicButton.play
        }
        set {
            self._musicState = newValue
        }
    }

    // MARK: Function
    func setMusicButton(typemusicbutton: TypeMusicButton, imageEdgeInset: CGFloat = 15) {
        self.layer.cornerRadius = self.frame.width / 2
        self.imageEdgeInsets = .init(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)

        switch typemusicbutton {
        case .play:
            self.musicState = .play
            self.setImage(UIImage(named: "play-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        case .pause:
            self.musicState = .pause
            self.setImage(UIImage(named: "pause-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color03
            self.tintColor = COLOR.color04
        case .prev:
            self.musicState = .prev
            self.setImage(UIImage(named: "previous-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        case .next:
            self.musicState = .next
            self.setImage(UIImage(named: "next-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.backgroundColor = COLOR.color05
            self.tintColor = COLOR.color06
        }
    }
}
