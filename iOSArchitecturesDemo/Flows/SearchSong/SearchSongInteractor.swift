//
//  SearchSongInteractor.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol SearchSongInteractorProtocol: class {
    
    func getSongs(query: String, completion: @escaping ([SongCellPresenterProtocol]?, Error?) -> Void)
}

class SearchSongInteractor: SearchSongInteractorProtocol {
   
    weak var presenter: SearchSongPresenterProtocol?
    private let searchService = ITunesSearchService()
    private let cellPresenterFactory = SongCellPresenterFactory()
    
    
    internal func getSongs(query: String, completion: @escaping ([SongCellPresenterProtocol]?, Error?) -> Void) {
        searchService.getSongs(forQuery: query) { [weak self] result in
            switch result {
            case .success(let songs):
                let cellPresenters = self?.makeCellPresenters(songs: songs)
                completion(cellPresenters, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func makeCellPresenters(songs: [ITunesSong]) -> [SongCellPresenterProtocol] {
        let cellPresenters = self.cellPresenterFactory.makeCellPresenters(songs: songs)
        return cellPresenters
    }
    
}
