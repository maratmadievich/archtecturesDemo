//
//  SongCell.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

final class SongCell: UITableViewCell {
    
    private let imageName: String = "iTunes"
    // MARK: - Subviews
    
    private(set) lazy var labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var labelArtist: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private(set) lazy var imageViewNote: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    var presenter: SongCellPresenterProtocol? {
        didSet {
            labelName.text = presenter?.name()
            labelArtist.text = presenter?.artist()
        }
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        self.labelName.text = nil
        self.labelArtist.text = nil
    }
    
}

extension SongCell {
    
    private func configureUI() {
        self.addImageViewNote()
        self.addLabelName()
        self.addLabelArtist()
    }
    
    private func addImageViewNote() {
        self.contentView.addSubview(self.imageViewNote)
        NSLayoutConstraint.activate([
            self.imageViewNote.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0),
            self.imageViewNote.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.imageViewNote.heightAnchor.constraint(equalToConstant: 40),
            self.imageViewNote.widthAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    private func addLabelName() {
        self.contentView.addSubview(self.labelName)
        NSLayoutConstraint.activate([
            self.labelName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.labelName.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.labelName.rightAnchor.constraint(equalTo: self.imageViewNote.leftAnchor, constant: -16)
            ])
    }
    
    private func addLabelArtist() {
        self.contentView.addSubview(self.labelArtist)
        NSLayoutConstraint.activate([
            self.labelArtist.topAnchor.constraint(equalTo: self.labelName.bottomAnchor, constant: 4.0),
            self.labelArtist.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.labelArtist.rightAnchor.constraint(equalTo: self.imageViewNote.leftAnchor, constant: -16)
            ])
    }
    
    
}

