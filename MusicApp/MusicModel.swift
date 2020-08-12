//
//  MusicListModel.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/25/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

class MusicModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var singer = ""
    @objc dynamic var author = ""
    @objc dynamic var cover_image_url = ""
    @objc dynamic var song_url = ""
    @objc dynamic var duration = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension MusicModel {
    func initFromJson(jsonData: [String: Any]) {
        self.id = jsonData["id"] as! Int
        self.name = jsonData["name"] as! String
        self.author = jsonData["author"] as! String
        self.singer = jsonData["singer"] as! String
        self.cover_image_url = jsonData["cover_image_url"] as! String
        self.song_url = jsonData["song_url"] as! String
        self.duration = jsonData["duration"] as! Int
    }
}

