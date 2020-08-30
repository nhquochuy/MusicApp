//
//  MusicListModel.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/25/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class MusicModel: Object {
    @objc dynamic var index = -1
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var singer = ""
    @objc dynamic var author = ""
    @objc dynamic var cover_image_url = ""
    @objc dynamic var song_url = ""
    @objc dynamic var duration = 0
    @objc dynamic var isSelected = false
    @objc dynamic var isPlaying = false
    
    override class func primaryKey() -> String? {
        return "index"
    }
}

extension MusicModel {
    func initFromJson(jsonData: NSDictionary) {
        self.id = jsonData["id"] as? Int ?? self.id
        self.name = jsonData["name"] as? String ?? self.name
        self.author = jsonData["author"] as? String ?? self.author
        self.singer = jsonData["singer"] as? String ?? self.singer
        self.cover_image_url = jsonData["cover_image_url"] as? String ?? self.cover_image_url
        self.song_url = jsonData["song_url"] as? String ?? self.song_url
        self.duration = jsonData["duration"] as? Int ?? self.duration
    }
}
