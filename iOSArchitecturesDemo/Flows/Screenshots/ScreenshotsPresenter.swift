//
//  ScreenshotsPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 29.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol ScreenshotsPresenterProtocol {
    var itemsCount: Int { get }
    func getCellPresenter(for row: Int) -> ScreenshotCellPresenterProtocol
}

class ScreenshotsPresenter: ScreenshotsPresenterProtocol {
    
    private let app: ITunesApp
    private let cellPresenterFactory = ScreenshotCellPresenterFactory()
    
    private var cellPresenters: [ScreenshotCellPresenterProtocol] = []
    
    init(app: ITunesApp) {
        self.app = app
        self.cellPresenters = cellPresenterFactory.makeCellPresenters(from: app)
    }
    
    internal var itemsCount: Int {
        return cellPresenters.count
    }
    
    internal func getCellPresenter(for row: Int) -> ScreenshotCellPresenterProtocol {
        return cellPresenters[row]
    }
    
}
