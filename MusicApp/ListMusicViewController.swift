//
//  ViewController.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/25/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import CoreLocation
import Alamofire

class ListMusicViewController: UIViewController {
    // MARK: Deinit
    deinit {
        print("ListMusciViewController deinit")
        self.notificationToken?.invalidate()
    }
    
    // MARK: Variable
    let urlAPIString = APIURL.apiMusicList
    let musicList = MusicRepository.shared.getAll()
    var notificationToken: NotificationToken? = nil
    
    // Instance
    let playerShared = AVPlayerHandler.shared
    let apiShared = APIHandler.shared
    let repositoryShared = MusicRepository.shared
    
    // MARK: Outlet
    @IBOutlet weak var coverImage: CircleImage!
    @IBOutlet weak var musicListTableView: UITableView!

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        self.doNotificationToken()
        self.observNotification()
        self.apiShared.parsingDataFromApi(urlString: urlAPIString)
        self.repositoryShared.resetDefaultStateProp()
    }
    
    // MARK: Function
    private func loadUI() {
        // Music list table view
        self.musicListTableView.dataSource = self
        self.musicListTableView.delegate = self
        self.musicListTableView.separatorStyle = .none
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // View
        self.view.backgroundColor = .color01
        self.view.insetsLayoutMarginsFromSafeArea = true
        
        // Cover image
        self.coverImage.image = UIImage(named: "music")
    }
    
    private func doNotificationToken(){
        notificationToken = self.musicList.observe(self.musicListTableView.applyChanges)
    }
    
    private func observNotification() {
        // Remove Observer
        NotificationCenter.default.removeObserver(self, name: NOTIFICATIONNAME.cellViewToListView, object: nil)
        NotificationCenter.default.removeObserver(self, name: NOTIFICATIONNAME.detailViewToListView, object: nil)
        
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(doMusic(notification:)), name: NOTIFICATIONNAME.detailViewToListView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doMusic(notification:)), name: NOTIFICATIONNAME.cellViewToListView, object: nil)
    }
      
    @objc func doMusic(notification: NSNotification) {
        if let data = notification.userInfo as? [String: Any] {
            let musicID = data["musicID"] as? Int ?? 0
            let isPlaying = data["isPlaying"] as? Bool ?? false
            self.changeCoverImage(musicID: musicID)
            self.repositoryShared.updateStateProp(id: musicID, isSelected: true, isPlaying: isPlaying)
        }
        //self.addPeriodicTimeObserver()
        self.addTimeObserver()
    }
    
    private func changeCoverImage(musicID: Int) {
        if let music = repositoryShared.getById(id: musicID) {
            guard let url = URL(string: music.cover_image_url) else { return }
            self.coverImage.loadCoverImage(url: url)
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//        self.playerShared.addTimeObserver(intervalTime: interval) {
//            [weak self] time  in
//            guard let this = self else { return }
//            this.updateUIBlock()
//        }
        self.playerShared.addTimeObserver(intervalTime: interval) { [weak self] (time) in
            guard let this = self else { return }
            this.updateUIBlock()
        }
    }
    
    private func removeTimeObserver() {
        self.playerShared.removeTimeObsever()
    }
    
    private func updateUIBlock() {
        self.coverImage.rotateCoverImage()
    }
}

// MARK: Extension
extension ListMusicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let music = self.musicList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListMusicTableViewCell
        
        // Cell Outlet
        cell.nameLabel.text = music.name
        cell.singerLabel.text = music.singer

        // Cell Variable
        cell.musicID = music.id
        
        // Cell Property
        cell.controlButton.setMusicButton(musicButtonState: (music.isPlaying) ? .pause : .play)
        cell.contentView.backgroundColor = (music.isSelected) ? .color02 : .color01

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Init
        let music = self.musicList[indexPath.row]
        self.removeTimeObserver()
        
        let detailView = storyboard?.instantiateViewController(identifier: "detailview") as! DetailMusicViewController
        self.navigationController?.pushViewController(detailView, animated: false)
        
        // Variable
        detailView.musicID = music.id
    }
}

