//
//  UpdatePresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 28.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol UpdatePresenterProtocol {
   
    func title() -> String
    func updateDate() -> String
    func description() -> String
}

class UpdatePresenter: UpdatePresenterProtocol {
    
    private let app: ITunesApp
    private let titleText = "Что нового?"
    
    init(app: ITunesApp) {
        self.app = app
    }
    
    func title() -> String {
        return self.titleText
    }
    
    func updateDate() -> String {
        if let releaseDate = self.app.currentVersionReleaseDate {
            let date = DateStringConverter.getDate(from: releaseDate, type: .timeWithTAndZ)
            let correctDateString = DateStringConverter.getString(from: date, type: .dateTime)
            return correctDateString
        } else {
            return ""
        }
       
    }
    func description() -> String {
        var returnedText = ""
        if let version = self.app.currentVersion {
            returnedText += "\(version)\n"
        }
        if let description = self.app.currentVersionDescription {
            returnedText += "\(description)"
        }
        return returnedText
    }
}
