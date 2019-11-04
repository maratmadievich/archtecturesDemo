//
//  Track.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 04.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

class Track {
   
    let song: ITunesSong
    var next: Track? = nil
    var previous: Track? = nil
    var playingState: PlayingState = .stop
    
    init(song: ITunesSong) {
        self.song = song
    }
    
    
}
