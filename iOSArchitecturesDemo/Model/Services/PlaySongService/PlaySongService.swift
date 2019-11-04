//
//  PlaySongService.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

//protocol PlaySongsServiceInterface: class {
//    var playlist: [ITunesSong] { get }
//    var currentTrack: [ITunesSong] { get }
//    func startPlay(_ song: ITunesSong)
//}

final class FakePlayer {//: PlaySongsServiceInterface {
    
    private init() {}
    private static let songTimeLimit: Int = 10
    private static var timer: Timer = Timer()
    
    var playlist: [Track] = []
    
    static let shared = FakePlayer()
    
    var currentTrack: Observable<Track?> = Observable(value: nil)
    
    
    func startPlay(_ song: ITunesSong) {
        for track in playlist {
            if track.song.trackName == song.trackName {
                currentTrack.value = track
                FakePlayer.shared.startTimer(for: track)
                return
            }
        }
        
    }
    
    func set(playlist: [ITunesSong]) {
        var tracklist = playlist.map({Track(song:$0)})
        
        for (index, track) in tracklist.enumerated() {
            if tracklist.count > index + 1 {
                track.next = tracklist[index + 1]
            }
            if index > 0 {
                track.previous = tracklist[index - 1]
            }
        }
        self.playlist = tracklist
    }
    
    func pausePlay() {
        guard let track = currentTrack.value else { return }
        switch track.playingState {
        case .isPlaying(let progress):
            invalidateTimer()
            track.playingState = .pause(progress: progress)
            currentTrack.value = track
        
        default:
            startTimer(for: track)
        }
    }
    
    func previous() {
        guard let track = currentTrack.value?.previous else { return }
        self.prepareStart(track: track)
    }
    
    func next() {
        guard let track = currentTrack.value?.next else { return }
        self.prepareStart(track: track)
    }
    
    
}

extension FakePlayer {
    
    private func prepareStart(track: Track) {
        self.invalidateTimer()
        track.playingState = .stop
        currentTrack.value = track
        FakePlayer.shared.startTimer(for: track)
    }
    
}

//MARK: - Timer Extension
extension FakePlayer {
    
    private func startTimer(for track: Track) {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            switch track.playingState {
            case .stop:
                track.playingState = .isPlaying(progress: 0)
            
            case .isPlaying(let progress):
                let newProgress = progress + 1
                if newProgress >= FakePlayer.songTimeLimit {
                    guard let next = track.next else {
                        track.playingState = .completed
                        return
                    }
                    self?.prepareStart(track: next)
                    
                } else {
                    track.playingState = .isPlaying(progress: progress + 1)
                }
                
            case .pause(let progress):
                track.playingState = .isPlaying(progress: progress)
                
            
            case .completed:
                timer.invalidate()
                
            }
            self?.currentTrack.value = track
        }
        RunLoop.main.add(timer, forMode: .common)
        FakePlayer.timer = timer
    }
    
    private func invalidateTimer() {
        FakePlayer.timer.invalidate()
    }
    
}
