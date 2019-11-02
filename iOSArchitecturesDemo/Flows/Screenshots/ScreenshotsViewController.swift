//
//  ScreenshotsView.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 29.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class ScreenshotsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let cellIdentifier = "ScreenshotCell"
    
    var presenter: ScreenshotsPresenterProtocol? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
}

extension ScreenshotsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemsCount = presenter?.itemsCount else {
            return 0
        }
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ScreenshotCell {
            cell.presenter = self.presenter?.getCellPresenter(for: indexPath.row)
            return cell
        } else {
            let cell = UICollectionViewCell()
            cell.backgroundColor = UIColor.green
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = self.view.frame.height
        let cellWidth: CGFloat = cellHeight/2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

extension ScreenshotsViewController {
    
    private func configureViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
}
