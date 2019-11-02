//
//  SearchSongPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchSongPresenterProtocol: class {
    var itemsCount: Int { get }
    
    init(view: SearchSongViewProtocol)
    func didEntered(query: String?)
    func getCellPresenter(for row: Int) -> SongCellPresenterProtocol
}

class SearchSongPresenter {
    
    private weak var view: SearchSongViewProtocol?
    private let searchService = ITunesSearchService()
    private let cellPresenterFactory = SongCellPresenterFactory()
    
    private var cellPresenters: [SongCellPresenterProtocol] = []
    
    required init(view: SearchSongViewProtocol) {
        self.view = view
    }
    
}

//MARK: - SearchSongPresenterProtocol
extension SearchSongPresenter: SearchSongPresenterProtocol {
    
    var itemsCount: Int {
        return cellPresenters.count
    }
    
    internal func getCellPresenter(for row: Int) -> SongCellPresenterProtocol {
        return cellPresenters[row]
    }
    
    internal func didEntered(query: String?) {
        guard let query = query,
            query.count != 0 else {
                self.view?.updateSearchBar(true)
                return
        }
        self.requestSongs(with: query)
    }
    
}

//MARK: - Private functions
extension SearchSongPresenter {
    
    private func requestSongs(with query: String) {
        self.view?.updateThrobber(isShow: true)
        self.cellPresenters.removeAll()
        self.view?.updateTableView()
        
        self.searchService.getSongs(forQuery: query) { [weak self] (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let songs):
                    self?.handleGet(songs: songs)
                    
                case .failure(let error):
                    self?.view?.show(error: error)
                }
            }
        }
    }
    
    
    private func handleGet(songs: [ITunesSong]) {
        if songs.count <= 0 {
            self.view?.updateEmptyResults(isHide: false)
        } else {
            self.cellPresenters = cellPresenterFactory.makeCellPresenters(songs: songs)
            self.view?.updateEmptyResults(isHide: true)
            self.view?.updateTableView()
        }
    }
    
}
