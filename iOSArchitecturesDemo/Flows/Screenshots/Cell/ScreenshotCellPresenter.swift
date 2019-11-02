//
//  ScreenshotCellPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol ScreenshotCellPresenterProtocol {
    func getImage(completion: @escaping (UIImage?) -> Void)
}

class ScreenshotCellPresenter: ScreenshotCellPresenterProtocol {
    
    private var url: URL?
    private let imageDownloader = ImageDownloader()
    
    init(imageUrlString: String?) {
        guard let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString) else { return }
        self.url = imageUrl
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = self.url else {
            completion(nil)
            return
        }
        self.imageDownloader.getImage(fromUrl: url) { (image, error) in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}
