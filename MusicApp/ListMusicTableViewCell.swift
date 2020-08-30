//
//  ListMusicTableViewCell.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/26/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit
import AVFoundation

class ListMusicTableViewCell: UITableViewCell {
    
    // MARK: Variable
    var musicID = 0
    var responseInfor: [String: Any]?
    
    // Instance
    var playerShared = AVPlayerHandler.shared
    
    // MARK: Outlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var controlButton: MusicButton!
    
    // MARK: Action
    @IBAction func controlButtonClick(_ sender: MusicButton) {
        // Remove Time Observer of Player
        self.playerShared.removeTimeObsever()
        // Init player if change Song
        self.initPlayer()
        // Handle Play or Pause Music
        self.actionPlayer(musicButtonState: sender.musicButtonState)
    }
    
    // MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Function
    private func initPlayer() {
        if self.playerShared.musicID != musicID {
            self.playerShared.initPlayer(urlString: "", musicID: musicID)
        }
    }
    
    private func actionPlayer(musicButtonState: MusicButtonState) {
        if musicButtonState == .play {
            self.playerShared.playPlayer()
            self.postNotification(isPlaying: true)
        } else {
            //AVPlayerHandler.shared.removeTimeObsever()
            self.playerShared.pausePlayer()
            self.postNotification(isPlaying: false)
        }
    }
    
    private func postNotification(isPlaying: Bool) {
        self.responseInfor = ["musicID" : musicID, "isPlaying" : isPlaying]
        NotificationCenter.default.post(name: NOTIFICATIONNAME.cellViewToListView, object: nil, userInfo: self.responseInfor)
    }
}
