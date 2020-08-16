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

class ListMusicViewController: UIViewController {
    // MARK: Deinit
    deinit {
        print("ListMusciViewController deinit")
        self.notificationToken?.invalidate()
    }
    
    // MARK: Variable
    let urlAPIString = "https://run.mocky.io/v3/e7d7c811-97b1-4a8e-a555-654ad6cb6280"
    let musicList = MusicRepository.instance.getAll()
    var notificationToken: NotificationToken? = nil
    var player: AVAudioPlayer?
    var timer: Timer?
    var playingMusicID = 0
    var musicListIndex = -1
    var angleCoverImage: CGFloat = 0
    var myMusicObjectList = [MusicObject]()
    
    // MARK: Outlet
    @IBOutlet weak var coverImage: CircleImage!
    @IBOutlet weak var musicListTableView: MusicListTableView!

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Build data for MusicObject
        musicList.forEach { (music) in
            let musicObject = MusicObject(id: music.id)
            myMusicObjectList.append(musicObject)
        }
        
        self.loadUI()
        self.doNotificationToken()
        self.getDataFromApi()
        self.observNotification()
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
        self.view.backgroundColor = COLOR.color01
        self.view.insetsLayoutMarginsFromSafeArea = true
        
        // Cover image
        self.coverImage.image = UIImage(named: "music")
    }

    private func doNotificationToken(){
        notificationToken = self.musicList.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.musicListTableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    private func getDataFromApi() {
        guard let url = URL(string: urlAPIString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, reponse, error) in
            guard let this = self else { return }
            guard let data = data else { return }
                        
            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else { return }
                
                jsonArray.forEach { (jsonData) in
                    let music = MusicModel()
                    music.initFromJson(jsonData: jsonData)
                    
                    if !this.isExistMusicId(musicId: music.id) {
                        let result = MusicRepository.instance.add(musicmodel: music)
                        print("Music Repository Add: ID = " + String(music.id) + " " + String(result))
                    }
                }
            } catch let error {
                print("Parsing Json Error: ", error)
            }
        }.resume()
    }
    
    private func isExistMusicId(musicId: Int) -> Bool {
        let music = MusicRepository.instance.getById(id: musicId)
        return music != nil
    }
    
    private func observNotification() {
        NotificationCenter.default.removeObserver(self, name: NOTIFICATIONNAME.doMusic, object: nil)
        NotificationCenter.default.removeObserver(self, name: NOTIFICATIONNAME.pushPlayingMusic, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(doMusic(notification:)), name: NOTIFICATIONNAME.doMusic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doMusic(notification:)), name: NOTIFICATIONNAME.pushPlayingMusic, object: nil)
    }
      
    @objc func doMusic(notification: NSNotification) {
        if let data = notification.userInfo as? [String: Any] {
            let musicID = data["musicID"] as! Int
            let indexPath = data["indexPath"] as! IndexPath
            let musicButtonState = data["musicButtonState"] as! MusicButtonState
            let currentTime = data["currentTime"] != nil ? data["currentTime"] as! Double : 0
            self.angleCoverImage = data["angleCoverImage"] != nil ? data["angleCoverImage"] as! CGFloat : self.angleCoverImage
            
            guard let music = MusicRepository.instance.getById(id: musicID) else { return }
            
            if self.playingMusicID != musicID || self.player == nil {
                self.playingMusicID = musicID
                self.initPlayer(songUrl: music.song_url, currentTime: currentTime )
            }

            self.callMusicAction(musicButtonState: musicButtonState)
            self.changeCoverImage(imageUrl: music.cover_image_url)
            
            self.myMusicObjectList.forEach { (Object) in
                if Object.id == musicID {
                    Object.musicState = musicButtonState
                    Object.contentColor = COLOR.color02
                } else {
                    Object.refreshData()
                }
            }
            
            self.refreshTableVIew(indexPath: indexPath, musicButtonState: musicButtonState)
        }
    }
    
    private func changeCoverImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        self.coverImage.loadCoverImage(url: url)
    }
    
    private func refreshTableVIew(indexPath: IndexPath, musicButtonState: MusicButtonState) {
        self.musicListTableView.reloadDataSavingSelections(indexPath: indexPath, musicButtonState: musicButtonState)
    }
    
    private func callMusicAction(musicButtonState: MusicButtonState) {
        if musicButtonState == .play {
            self.pauseMusic()
        } else {
            self.playMusic()
        }
    }
}

// MARK: Extension
extension ListMusicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Init
        let music = self.musicList[indexPath.row]
        let musicObjects = self.myMusicObjectList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListMusicTableViewCell
        
        // Cell Outlet
        cell.nameLabel.text = music.name
        cell.singerLabel.text = music.singer

        // Cell Variable
        cell.musicID = music.id
        cell.indexPath = indexPath
        cell.controlButton.setMusicButton(musicButtonState: musicObjects.musicState)
        cell.contentView.backgroundColor = musicObjects.contentColor
        
        // Call Back closure
        cell.controlButtonClickAction = {
            (buttonState) in
            musicObjects.musicState = buttonState
            musicObjects.contentColor = COLOR.color02
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Init
        let music = self.musicList[indexPath.row]
        
        let detailView = storyboard?.instantiateViewController(identifier: "detailview") as! DetailMusicViewController
        self.navigationController?.pushViewController(detailView, animated: false)
        
        // Outlet
        detailView.angleCoverImage = self.angleCoverImage
        
        // Variable
        detailView.musicIndex = indexPath.row
          
        if let player = self.player {
            if player.isPlaying && self.playingMusicID == music.id {
                detailView.playingMusicID = music.id
                detailView.currentTimePlayingMusic = Double(player.currentTime)
            }
        }
        
        self.pauseMusic()
    }
}

// Do Music
extension ListMusicViewController {
    func initPlayer(songUrl: String, currentTime: Double) {
        print("Init Player!")
        if self.player != nil {
            self.player = nil
        }
        guard let url = URL(string: songUrl) else { return }
        do {
            let data = try Data(contentsOf: url)
            
            do {
                player = try AVAudioPlayer(data: data)
                player?.currentTime = currentTime
                player?.prepareToPlay()
            } catch {
                print("playMusic: Error at Player")
            }
        } catch {
            print("playMusic: Error at Data")
        }
    }
    
    func playMusic() {
        print("Play Music!")
        guard let player = self.player else { return }
        player.play()
        self.timerStart()
    }
    
    func pauseMusic() {
        print("Pause Music!")
        if player != nil {
            guard let player = self.player else { return }
            player.stop()
            self.timerStop()
        }
    }
}

// Do timer
extension ListMusicViewController {
    func timerStart() {
        print("Timer Start!")
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] (time) in
            guard let this = self else { return }
            if this.player?.isPlaying == false {
                this.musicListTableView.reloadData()
                this.timerStop()
            }
            this.rotateCoverImage()
        })
        self.runLoopMain()
    }
    
    func runLoopMain() {
        guard let timer = self.timer else { return }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func timerStop() {
        print("Timer Stop!")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func rotateCoverImage() {
        self.angleCoverImage = (self.angleCoverImage == 360) ? 0 : (self.angleCoverImage + 1)
        self.coverImage.transform = .init(rotationAngle: CGFloat.pi * self.angleCoverImage / 180)
    }
}

