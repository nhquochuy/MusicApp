//
//  MusicObject.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/11/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class MusicObject: NSObject {
    var id = 0
    var contentColor = COLOR.color01
    var musicState = MusicButtonState.play
    
    init(id: Int) {
        self.id = id
    }
    
    func refreshData() {
        self.contentColor = COLOR.color01
        self.musicState = MusicButtonState.play
    }
}
