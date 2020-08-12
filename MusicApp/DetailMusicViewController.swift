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
    let musicList = MusicRepository.instance.getAll()
    var musicIndex = 0
    var playingMusicID = -1
    var currentTimePlayingMusic: Double = 0
    var timer: Timer?
    var angleCoverImage: CGFloat = 0
    var player: AVAudioPlayer?
    var isPlayingState = false
    var responseInfor: [String: Any]?
    
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
        self.navigationController?.popViewController(animated: true)
        self.postNotification()
        self.pauseMusic()
    }
    
    @IBAction func playButtonClick(_ sender: MusicButton) {
        self.convertMusicButton(sender)
        self.callMusicAction()
    }
    
    @IBAction func prevButtonClick(_ sender: MusicButton) {
        self.getMusicIndex(musicButtonState: sender.musicButtonState)
        self.doMusic()
    }
    
    @IBAction func nextButtonClick(_ sender: MusicButton) {
        self.getMusicIndex(musicButtonState: sender.musicButtonState)
        self.doMusic()
    }
    
    @IBAction func timeSliderChange(_ sender: UISlider) {
        self.currentTimeLabel.text = self.changeTimeFormat(second: Int(sender.value))
        
        if let player = self.player {
            player.currentTime = Double(sender.value)
            player.prepareToPlay()
            player.play()
            self.timerStart()
        }
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.doMusic()
        //self.setupObjectsControl(musicIndex: self.musicIndex)
    }
    
    // MARK: Func
    private func getMusicIndex(musicButtonState: MusicButtonState) {
        let musicListCount = musicList.count
        if musicButtonState == .next {
            if musicIndex == musicListCount - 1 {
                musicIndex = 0
            } else {
                musicIndex += 1
            }
        } else {
            if self.musicIndex == 0 {
                self.musicIndex = musicListCount - 1
            } else {
                self.musicIndex -= 1
            }
        }
    }
    
    private func setupObjectsControl(musicIndex: Int) {
        self.loadCoverImage()
        self.loadNameSingerLabel()
        self.loadTimeLabel()
        self.loadSlider()
        self.loadControlButton()
    }
    
    private func setupView() {
        self.view.backgroundColor = COLOR.color04
        self.view.insetsLayoutMarginsFromSafeArea = true
    }
    
    private func loadCoverImage() {
        let music = musicList[self.musicIndex]
        guard let url = URL(string: music.cover_image_url) else { return }
        
        self.coverImage.loadCoverImage(url: url)
    }
    
    private func loadNameSingerLabel() {
        let music = self.musicList[self.musicIndex]
        
        self.nameLabel.text = music.name
        self.singerLabel.text = music.singer
    }
    
    private func loadSlider() {
        let music = self.musicList[self.musicIndex]
        let currentTime = self.currentTimePlayingMusic
        self.timeSlider.minimumValue = 0
        self.timeSlider.maximumValue = Float(music.duration)
        self.timeSlider.value = Float(currentTime)
    }
    
    private func loadTimeLabel() {
        let music = self.musicList[self.musicIndex]
        let currentTime = self.currentTimePlayingMusic
        
        print(music.duration)
        self.currentTimeLabel.text = self.changeTimeFormat(second: Int(currentTime))
        self.durationTimeLabel.text = self.changeTimeFormat(second: music.duration)
    }
    
    private func loadControlButton() {
        
        let isPlaying = (self.player?.isPlaying) ?? false
        
        if isPlaying {
            self.playButton.setMusicButton(musicButtonState: .pause, imageEdgeInset: 27)
        } else {
            self.playButton.setMusicButton(musicButtonState: .play, imageEdgeInset: 27)
        }
        self.prevButton.setMusicButton(musicButtonState: .prev, imageEdgeInset: 20)
        self.nextButton.setMusicButton(musicButtonState: .next, imageEdgeInset: 20)
    }
    
    private func changeTimeFormat(second: Int) -> String {
        let minString = String(format: "%02d", second / 60)
        let secondString = String(format: "%02d", second % 60)
        
        return minString + ":" + secondString
    }
    
    private func convertMusicButton(_ sender: MusicButton) {
        if sender.musicButtonState == .play {
            sender.setMusicButton(musicButtonState: .pause, imageEdgeInset: 27)
        } else {
            sender.setMusicButton(musicButtonState: .play, imageEdgeInset: 27)
        }
    }
    
    private func doMusic() {
        let music = musicList[musicIndex]
        
        if self.playingMusicID != music.id || self.player == nil {
            self.playingMusicID = music.id
            self.initPlayer(songUrl: music.song_url)
        }
        
        if self.currentTimePlayingMusic > 0 || self.isPlayingState {
            self.currentTimePlayingMusic = 0
            self.playMusic()
        }
        
        self.setupObjectsControl(musicIndex: self.musicIndex)
    }
    
    private func postNotification() {
        let music =  musicList[musicIndex]
        guard let player = self.player else { return }
        responseInfor = ["musicButtonState": !(player.isPlaying) ? MusicButtonState.play : MusicButtonState.pause, "musicID": music.id ,"indexPath": IndexPath.init(row: musicIndex, section: 0) , "currentTime": player.currentTime, "angleCoverImage" : self.angleCoverImage]
        NotificationCenter.default.post(name: NOTIFICATIONNAME.pushPlayingMusic, object: nil, userInfo: responseInfor)
    }
}

// MARK: Extension
// Do Music
extension DetailMusicViewController {
    func initPlayer(songUrl: String) {
        print ("init Player")

        guard let url = URL(string: songUrl) else { return }
        do {
            let data = try Data(contentsOf: url)
            do {
                player = try AVAudioPlayer(data: data)
                player?.currentTime = self.currentTimePlayingMusic
                player?.prepareToPlay()
            } catch {
                print("playMusic: Error at Player")
            }
        } catch {
            print("playMusic: Error at Data")
        }
    }
    
    func playMusic() {
        self.playButton.setMusicButton(musicButtonState: .pause, imageEdgeInset: 27)
        self.isPlayingState = true
        guard let player = self.player else { return }
        player.play()
        self.timerStart()
    }
    
    func pauseMusic() {
        self.playButton.setMusicButton(musicButtonState: .play, imageEdgeInset: 27)
        self.isPlayingState = false
        guard let player = self.player else { return }
        player.stop()
        self.timerStop()
    }
    
    private func callMusicAction() {
        guard let player = self.player else { return }
        
        if player.isPlaying {
            self.pauseMusic()
        } else {
            self.playMusic()
        }
    }
}

// Do timer
extension DetailMusicViewController {
    func timerStart() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] (time) in
            guard let this = self else { return }
            //print(this.player)
            guard let player = this.player else { return }
            if !player.isPlaying {
                this.timerStop()
            }
            this.updateTimeSlider()
            this.updateCurrentTimeLabel()
            this.rotateCoverImage()
        })
        self.runLoopMain()
    }
    
    func runLoopMain() {
        guard let timer = self.timer else { return }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func timerStop() {
        timer?.invalidate()
        self.timer = nil
    }
    
    func updateTimeSlider() {
        if let player = self.player {
            self.timeSlider.value = Float(player.currentTime)
        }
    }
    
    func updateCurrentTimeLabel() {
        if let player = self.player {
            self.currentTimeLabel.text = self.changeTimeFormat(second: Int(player.currentTime))
        }
    }
    
    func rotateCoverImage() {
        self.angleCoverImage = (self.angleCoverImage == 360) ? 0 : (self.angleCoverImage + 1)
        self.coverImage.transform = .init(rotationAngle: CGFloat.pi * self.angleCoverImage / 180)
    }
}
