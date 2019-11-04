//
//  SongList.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 04.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

class SongList {
   
    var songs: [ITunesSong]
    
    init(songs: [ITunesSong]) {
        self.songs = songs
    }
}
