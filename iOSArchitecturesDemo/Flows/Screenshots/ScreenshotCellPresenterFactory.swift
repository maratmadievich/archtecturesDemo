//
//  ScreenshotCellPresenterFactory.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

class ScreenshotCellPresenterFactory {
    
    func makeCellPresenters(from app: ITunesApp) -> [ScreenshotCellPresenterProtocol] {
        var cellPresenters: [ScreenshotCellPresenterProtocol] = []
        
        for screenShotUrlString in app.screenshotUrls {
            let cellPresenter = ScreenshotCellPresenter(imageUrlString: screenShotUrlString)
            cellPresenters.append(cellPresenter)
        }
        return cellPresenters
    }
}
