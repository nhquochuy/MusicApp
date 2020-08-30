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
//        let urlString = "https://data56.chiasenhac.com/downloads/1153/0/1152314-266359e8/128/Blue%20-%20Big%20Bang.mp3"
//
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


