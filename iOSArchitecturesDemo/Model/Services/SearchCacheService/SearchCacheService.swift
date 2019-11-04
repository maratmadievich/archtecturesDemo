//
//  SearchCacheService.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 04.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol SearchCacheInterface {
    func getSongs(for query: String) -> [ITunesSong]?
    func save(songs: [ITunesSong], for query: String)
}
class SearchCacheService: SearchCacheInterface {
    
    static let shared = SearchCacheService()
    private init() {}
    
    private var cache = NSCache<NSString, SongList>()
    
    func getSongs(for query: String) -> [ITunesSong]? {
        let key = NSString(string: query)
        let songList: [ITunesSong]? = cache.object(forKey: key)?.songs
        return songList
    }
    
    func save(songs: [ITunesSong], for query: String) {
        let key = NSString(string: query)
        let songList = SongList(songs: songs)
        cache.setObject(songList, forKey: key)
    }
    
    
}
