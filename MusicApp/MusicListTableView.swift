//
//  MusicListTableView.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/16/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class MusicListTableView: UITableView {

    func reloadDataSavingSelections(indexPath: IndexPath?, musicButtonState: MusicButtonState) {
          
          self.reloadData()
          
          if let rowIndex = indexPath {
              let cell = self.cellForRow(at: rowIndex) as! ListMusicTableViewCell
              cell.isSelected = true
              cell.controlButton.setMusicButton(musicButtonState: musicButtonState)
          }
      }
}
