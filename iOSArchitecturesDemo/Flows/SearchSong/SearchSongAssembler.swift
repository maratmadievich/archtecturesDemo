//
//  SearchSongAssembler.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

class SearchSongAssembler {
    
    func assemble(view: SearchSongView) {
        let router = SearchSongRouter()
        router.view = view
        
        let interactor = SearchSongInteractor()
    
        let presenter = SearchSongPresenter(interactor: interactor, router: router)
        presenter.view = view
        
        interactor.presenter = presenter
        
        view.presenter = presenter
    }
}
