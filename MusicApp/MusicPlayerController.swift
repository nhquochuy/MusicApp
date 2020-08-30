//
//  MusicPlayerController.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/16/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerController {
    static let shared = MusicPlayerController()
    
    private init() {}
    
    private var player: AVPlayer?
    
    internal func playerInit(url: URL) {
        player = .init(url: url)
    }
    
    internal func playerPlay() {
        if let player = self.player {
            player.play()
        }
    }
    
    internal func playerPause() {
        if let player = self.player {
            player.pause()
        }
    }
}
