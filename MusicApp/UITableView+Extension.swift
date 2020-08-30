//
//  File.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/17/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UITableView {
    func applyChanges<T>(changes: RealmCollectionChange<T>){
        switch changes {
        case .initial:
            // Results are now populated and can be accessed without blocking the UI
            self.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed, so apply them to the UITableView
            self.beginUpdates()
            // Always apply updates in the following order: deletions, insertions, then modifications.
            // Handling insertions before deletions may result in unexpected behavior.
            self.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            self.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            self.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            self.endUpdates()
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }
}
