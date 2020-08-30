//
//  AVPlayer+Handler.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/21/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerHandler {
    
    // MARK: Variable
    static let shared = AVPlayerHandler()
    
    private var _player: AVPlayer?

    var player: AVPlayer? {
        get {
            return self._player
        }

        set {
            self._player = newValue
        }
    }
    
    var musicID: Int?
    var timeObsever: Any?
    
    // MARK: Init
    private init() {}
    
    // MARK: Function
    func initPlayer(urlString: String, musicID: Int) {
//        let urlString = "https://data25.chiasenhac.com/download2/2114/1/2113754-a7ae2820/128/Dao%20Mo%20But%20Ky%20Thap%20Nien%20Nhan%20Gian%20-%20Quac.mp3"

        if let url = URL(string: urlString) {
            print("AVPlayerHandler -> initPlayer: Player Inited With \(urlString)")
            self.player = AVPlayer(url: url)
            self.musicID = musicID
        } else {
            print("AVPlayerHandler -> initPlayer: Could Not Init Player With \(urlString)")
        }
    }
    
    func playPlayer() {
        if let player = self.player {
            print("AVPlayerHandler -> playPlayer: Music Play")
            player.play()
        } else {
            print("AVPlayerHandler -> playPlayer: Music Could Not Play")
        }
    }
    
    func pausePlayer() {

        if let player = self.player {
            print("AVPlayerHandler -> pausePlayer: Music Pause")
            player.pause()
        } else {
            print("AVPlayerHandler -> pausePlayer: Music Could Not Pause")
        }
    }
    
    func addTimeObserver(intervalTime: CMTime, updateUI: @escaping (CMTime) -> Void) {
        if let player = self.player {
            self.timeObsever = player.addPeriodicTimeObserver(forInterval: intervalTime, queue: .main, using: { (time) in
                updateUI(time)
            })
        }
    }
    
    func removeTimeObsever() {
        if let player = self.player {
            print("AVPlayerHandler -> removeTimeObsever: Remove TIme Obsever")
            if let timeObserve = self.timeObsever {
                player.removeTimeObserver(timeObserve)
                self.timeObsever = nil
            }
        }
    }
}


