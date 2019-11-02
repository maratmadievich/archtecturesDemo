//
//  ScreenshotCell.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 29.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewScreenshot: UIImageView?
    
    var presenter: ScreenshotCellPresenterProtocol? {
        didSet {
            presenter?.getImage { [weak self] image in
                self?.imageViewScreenshot?.image = image
            }
        }
    }
    
    
}
