//
//  UpdateView.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 28.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {
    
    @IBOutlet private weak var labelTitle:       UILabel?
    @IBOutlet private weak var labelUpdateDate: UILabel?
    @IBOutlet private weak var labelDescription: UILabel?
    
    var presenter: UpdatePresenterProtocol? {
        didSet {
            self.labelTitle?.text = self.presenter?.title()
            self.labelUpdateDate?.text = self.presenter?.updateDate()
            self.labelDescription?.text = self.presenter?.description()
        }
    }
    

}
