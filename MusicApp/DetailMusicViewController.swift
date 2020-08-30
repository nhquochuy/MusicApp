//
//  DetailMusicViewController.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/2/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit
import AVFoundation

class DetailMusicViewController: UIViewController {
    // MARK: Deinit
    deinit {
        print("DetailMusicViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Variable
    let musicList = MusicRepository.shared.getAll()
    var isPlayingState = false
    var responseInfor: [String: Any]?
    var musicID = 0 {
        didSet {
            self.updateMusic()
        }
    }
    var music: MusicModel?
    
    // Instance
    let playerShared = AVPlayerHandler.shared
    let musicRepositoryShared = MusicRepository.shared
    
    // MARK: Outlet
    @IBOutlet weak var coverImage: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var playButton: MusicButton!
    @IBOutlet weak var prevButton: MusicButton!
    @IBOutlet weak var nextButton: MusicButton!
    @IBOutlet weak var dismissButton: MusicButton!
    
    // MARK: Action
    @IBAction func dismissButtonClick(_ sender: UIButton) {
        self.removeTimeObserver()
        self.postNotification(isPlaying: isPlayingState)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonClick(_ sender: MusicButton) {
        self.removeTimeObserver()
        self.initPlayer()
        self.actionPlayer(musicButtonState: sender.musicButtonState)
        self.doMusic()
    }
    
    @IBAction func prevButtonClick(_ sender: MusicButton) {
        self.removeTimeObserver()
        self.changeMusicID(musicButtonState: sender.musicButtonState)
        self.setupObjectsControl()
        self.doMusic()
    }
    
    @IBAction func nextButtonClick(_ sender: MusicButton) {
        self.removeTimeObserver()
        self.changeMusicID(musicButtonState: sender.musicButtonState)
        self.setupObjectsControl()
        self.doMusic()
    }
    
    @IBAction func timeSliderChange(_ sender: UISlider) {
        if let player = self.playerShared.player {
            let changeTime = CMTime(seconds: Double(sender.value), preferredTimescale: 1)
            
            player.seek(to: changeTime) { [weak self] (isComplate) in
                guard let this = self else { return }
                this.currentTimeLabel.text = this.changeTimeFormat(second: Int(sender.value))
            }
        }
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.loadUI()
        //self.doMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUI()
        self.doMusic()
    }
    
    // MARK: Func
    private func changeMusicID(musicButtonState: MusicButtonState) {
        if let music = self.music, let index = self.musicList.index(of: music) {
            if musicButtonState == .next {
                self.changeMusicIDNext(index: index)
            } else {
                self.changeMusicIDPre(index: index)
            }
        }
    }
    
    private func changeMusicIDNext(index: Int) {
        var nextIndex = index  + 1
        nextIndex = self.musicList.indices.contains(nextIndex) ? nextIndex : 0
        self.musicID = self.musicList[nextIndex].id
    }
    
    private func changeMusicIDPre(index: Int) {
        var preIndex = index - 1
        preIndex = self.musicList.indices.contains(preIndex) ? preIndex : (self.musicList.count - 1)
        self.musicID = self.musicList[preIndex].id
    }
    
    private func loadUI() {
        // Basic View
        self.setupView()
        // Object Control
        self.setupObjectsControl()
    }
    
    private func setupObjectsControl() {
        self.loadCoverImage()
        self.loadNameSingerLabel()
        self.loadTimeLabel()
        self.loadSlider()
        self.loadControlButton()
    }
    
    private func setupView() {
        self.view.backgroundColor = .color04
        self.view.insetsLayoutMarginsFromSafeArea = true
    }
    
    private func loadCoverImage() {
        if let music = self.music {
            guard let url = URL(string: music.cover_image_url) else { return }
            self.coverImage.loadCoverImage(url: url)
        }
    }
    
    private func loadNameSingerLabel() {
        if let music = self.music {
            self.nameLabel.text = music.name
            self.singerLabel.text = music.singer
        }
    }
    
    private func loadSlider() {
        if let music = self.music {
            let currentPlayingTime = self.getCurrentPlayingTime()
            
            self.timeSlider.minimumValue = 0
            self.timeSlider.maximumValue = Float(music.duration)
            self.timeSlider.value = Float(currentPlayingTime)
        }
    }
    
    private func loadTimeLabel() {
        if let music = self.music {
            let currentPlayingTime = self.getCurrentPlayingTime()
            
            self.currentTimeLabel.text = self.changeTimeFormat(second: currentPlayingTime)
            self.durationTimeLabel.text = self.changeTimeFormat(second: music.duration)
        }
    }
    
    private func loadControlButton() {
        if let music = self.music {
            if music.isPlaying {
                self.playButton.setMusicButton(musicButtonState: .pause, imageEdgeInset: 27)
            } else {
                self.playButton.setMusicButton(musicButtonState: .play, imageEdgeInset: 27)
            }
            self.prevButton.setMusicButton(musicButtonState: .prev, imageEdgeInset: 20)
            self.nextButton.setMusicButton(musicButtonState: .next, imageEdgeInset: 20)
        }
    }
    
    private func getCurrentPlayingTime() -> Int {
        var currentTime = 0
        
        if let music = self.music, let player = self.playerShared.player {
            currentTime = Int((music.isPlaying) ? CMTimeGetSeconds(player.currentTime()) : 0)
        }
        
        return currentTime
    }
    
    private func changeTimeFormat(second: Int) -> String {
        let minString = String(format: "%02d", second / 60)
        let secondString = String(format: "%02d", second % 60)
        
        return minString + ":" + secondString
    }
    
    private func convertMusicButton(musicButtonState: MusicButtonState) {
        if musicButtonState == .play {
            self.playButton.setMusicButton(musicButtonState: .pause, imageEdgeInset: 27)
        } else {
            self.playButton.setMusicButton(musicButtonState: .play, imageEdgeInset: 27)
        }
    }
    
    private func doMusic() {
        if let music = self.music {
            if music.isPlaying {
                //self.addPeriodicTimeObserver()
                self.addTimeObserver()
            }
        }
    }
    
    private func actionPlayer(musicButtonState: MusicButtonState) {
        if musicButtonState == .play {
            self.actionPlayBlock()
        } else {
            self.actionPauseBlock()
        }
    }
    
    private func actionPlayBlock() {
        self.playerShared.playPlayer()
        self.convertMusicButton(musicButtonState: .play)
        self.musicRepositoryShared.updateStateProp(id: musicID, isSelected: true, isPlaying: true)
        self.isPlayingState = true
    }
    
    private func actionPauseBlock() {
        self.playerShared.pausePlayer()
        self.convertMusicButton(musicButtonState: .pause)
        self.musicRepositoryShared.updateStateProp(id: musicID, isSelected: true, isPlaying: false)
        self.isPlayingState = false
    }
    
    private func initPlayer() {
        if self.playerShared.musicID != self.musicID {
            self.playerShared.initPlayer(urlString: "", musicID: musicID)
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.playerShared.addTimeObserver(intervalTime: interval) {
            [weak self] (time) in
            guard let this = self else { return }
            this.updateUIBlock(time: time)
        }
    }
    
    private func removeTimeObserver() {
        self.playerShared.removeTimeObsever()
    }
    
    private func updateUIBlock(time: CMTime) {
        self.coverImage.rotateCoverImage()
        //let currentPlayingTime = CMTimeGetSeconds(player.currentTime())
        let currentPlayingTime = CMTimeGetSeconds(time)
        self.timeSlider.value = Float(currentPlayingTime)
        self.currentTimeLabel.text = self.changeTimeFormat(second: Int(currentPlayingTime))
    }
    
    private func postNotification(isPlaying: Bool) {
        self.responseInfor = (self.isPlayingState) ? ["musicID": self.musicID, "isPlaying" : isPlaying] : nil
        NotificationCenter.default.post(name: NOTIFICATIONNAME.detailViewToListView, object: nil, userInfo: self.responseInfor)
    }
    
    private func updateMusic() {
        self.music = musicRepositoryShared.getById(id: self.musicID)
    }
}


