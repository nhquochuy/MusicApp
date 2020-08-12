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
    var indexPath: IndexPath?
    var contentColor = COLOR.color01
    
    var controlButtonClickAction: ((MusicButtonState) -> Void)?
    
    // MARK: Outlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var controlButton: MusicButton!
    
    // MARK: Action
    @IBAction func controlButtonClick(_ sender: MusicButton) {
        self.convertMusicState(sender)
        self.responseInfor = ["musicID" : self.musicID, "indexPath" : self.indexPath as Any, "musicButtonState" : sender.musicButtonState]
        self.postNotification()
        
        self.controlButtonClickAction?(sender.musicButtonState)
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
    private func setContentViewColor() {
        self.isSelected = true
    }
    
    private func convertMusicState(_ button: MusicButton) {
        if button.musicButtonState == .play  {
            button.musicButtonState = .pause
        } else {
            button.musicButtonState = .play
        }
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: NOTIFICATIONNAME.doMusic, object: nil, userInfo: self.responseInfor)
    }
}
