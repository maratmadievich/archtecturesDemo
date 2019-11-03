//
//  SongCellPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol SongCellPresenterProtocol {
    func name() -> String
    func artist() -> String
    func getSong() -> ITunesSong
}

class SongCellPresenter: SongCellPresenterProtocol {
    
    private var song: ITunesSong
    private let noArtistText = "Не указано"
    
    init(song: ITunesSong) {
        self.song = song
    }
    
    func name() -> String {
        let returnedText: String = self.song.trackName
        return returnedText
    }
    
    func artist() -> String {
        let returnedText: String = self.song.artistName ?? noArtistText
        return returnedText
    }
    
    func getSong() -> ITunesSong {
        return self.song
    }
    
}
