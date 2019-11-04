//
//  PlayerViewModel.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol PlayerViewModelProtocol {
    var trackName: Observable<String?> { get }
    var artist: Observable<String?> { get }
    var time: Observable<String?> { get }
    var buttonPlayPauseImage: Observable<UIImage?> { get }
    
    func viewDidLoad()
    func previousTapped()
    func playPauseTapped()
    func nextTapped()
}

class PlayerViewModel {
    // MARK: - Observable properties
    
    let trackName = Observable<String?>(value: nil)
    let artist = Observable<String?>(value: nil)
    let time = Observable<String?>(value: nil)
    let buttonPlayPauseImage = Observable<UIImage?>(value: nil)
    
    private var startSong: ITunesSong
    private var playerService = FakePlayer.shared
    
    private let imagePause = UIImage(named: "pause")
    private let imagePlay = UIImage(named: "play")
    
    // MARK: - Init
    
    init(song: ITunesSong, allSongs: [ITunesSong]) {
        self.startSong = song
        
        playerService.set(playlist: allSongs)
        playerService.currentTrack.addObserver(anyObject: self) { [weak self] (_, track) in
            print(track)
            if let track = track {
                self?.trackName.value = track.song.trackName
                self?.artist.value = track.song.artistName
                
                switch track.playingState {
                case .isPlaying(let progress):
                    self?.time.value = self?.getTime(progress: progress)
                    self?.buttonPlayPauseImage.value = self?.imagePause
                case .pause(let progress):
                    self?.time.value = self?.getTime(progress: progress)
                    self?.buttonPlayPauseImage.value = self?.imagePlay
                default:
                    self?.time.value = "0:00"
                    self?.buttonPlayPauseImage.value = self?.imagePlay
                }
            }
        }

    }
    

}

extension PlayerViewModel: PlayerViewModelProtocol {
    
    func viewDidLoad() {
        playerService.startPlay(startSong)
    }
    
    func previousTapped() {
        playerService.previous()
    }
    
    func playPauseTapped() {
        playerService.pausePlay()
    }
    
    func nextTapped() {
        playerService.next()
    }
    
}

extension PlayerViewModel {
    
    private func getTime(progress: Int) -> String {
        let minutes = progress / 60
        let seconds = progress % 60
        
        let time: String = seconds > 9
            ? "\(minutes):\(seconds)"
            : "\(minutes):0\(seconds)"
        return time
    }
    
}
