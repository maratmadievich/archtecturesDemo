//
//  SongCellPresenterFactory.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

class SongCellPresenterFactory {
    
    func makeCellPresenters(songs: [ITunesSong]) -> [SongCellPresenterProtocol] {
        var cellPresenters: [SongCellPresenterProtocol] = []
        
        for song in songs {
            let cellPresenter = SongCellPresenter(song: song)
            cellPresenters.append(cellPresenter)
        }
        return cellPresenters
    }
    
}
