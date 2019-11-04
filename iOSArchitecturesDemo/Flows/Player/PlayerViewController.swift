//
//  PlayerViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    private weak var stackViewMain: UIStackView?
    private weak var imageViewCollection: UIImageView?
    private weak var labelName: UILabel?
    private weak var labelArtist: UILabel?
    
    private weak var stackViewButtons: UIStackView?
    private weak var buttonPrevious: UIButton?
    private weak var buttonPlayPause: UIButton?
    private weak var buttonNext: UIButton?
    private weak var labelTime: UILabel?
    
    var viewModel: PlayerViewModelProtocol

    init(viewModel: PlayerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.configureObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let navigationTitle: String = "Player"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.viewDidLoad()
    }
    
}

//MARK: - Observers
extension PlayerViewController {
    
    private func configureObservers() {
        viewModel.trackName.addObserver(anyObject: self) {
            [weak self] (_, trackName) in
            self?.labelName?.text = trackName
        }
        
        viewModel.artist.addObserver(anyObject: self) {
            [weak self] (_, artist) in
            self?.labelArtist?.text = artist
        }
        
        viewModel.time.addObserver(anyObject: self) {
            [weak self] (_, time) in
            self?.labelTime?.text = time
        }
        
        viewModel.buttonPlayPauseImage.addObserver(anyObject: self) {
            [weak self] (_, image) in
            self?.buttonPlayPause?.setImage(image, for: .normal)
            self?.buttonPlayPause?.setImage(image, for: .highlighted)
        }
    }
    
}

//MARK: - Actions
extension PlayerViewController {
    
    @objc
    private func buttonPreviousTapped() {
        viewModel.previousTapped()
    }
    
    @objc
    private func buttonPlayPauseTapped() {
        viewModel.playPauseTapped()
    }
    
    @objc
    private func buttonNextTapped() {
        viewModel.nextTapped()
    }
    
}

//MARK: - Configure UI
extension PlayerViewController {
    
    private func configureUI() {
        self.view.backgroundColor = UIColor.white
        configureNavigation()
        configureStackViewMain()
        configureImageViewCollection()
        configureLabelName()
        configureLabelArtist()
        configureStackViewButtons()
        configureButtonPrevious()
        configureButtonPlayPause()
        configureButtonNext()
        configureLabelTime()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = navigationTitle
    }
    
    private func configureStackViewMain() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor.red
        self.view.addSubview(stackView)
        self.stackViewMain = stackView
        activateStackViewMainConstraints()
    }
    
    private func configureImageViewCollection() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "iTunes")
        imageView.contentMode = .scaleAspectFit
        self.stackViewMain?.addArrangedSubview(imageView)
        self.imageViewCollection = imageView
        activateImageViewCollectionConstraints()
    }
    
    private func configureLabelName() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        self.stackViewMain?.addArrangedSubview(label)
        self.labelName = label
        activateLabelNameConstraints()
    }
    
    private func configureLabelArtist() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        self.stackViewMain?.addArrangedSubview(label)
        self.labelArtist = label
        activateLabelArtistConstraints()
    }
    
    private func configureStackViewButtons() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        self.stackViewMain?.addArrangedSubview(stackView)
        self.stackViewButtons = stackView
        activateStackViewButtonsConstraints()
    }
    
    private func configureButtonPrevious() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "previous") {
            button.setImage(image, for: .normal)
            button.setImage(image, for: .highlighted)
        }
        button.addTarget(self, action:#selector(self.buttonPreviousTapped), for: .touchUpInside)
        self.stackViewButtons?.addArrangedSubview(button)
        self.buttonPrevious = button
        activateButtonPreviousConstraints()
    }
    
    private func configureButtonPlayPause() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "pause") {
            button.setImage(image, for: .normal)
            button.setImage(image, for: .highlighted)
        }
        button.addTarget(self, action:#selector(self.buttonPlayPauseTapped), for: .touchUpInside)
        self.stackViewButtons?.addArrangedSubview(button)
        self.buttonPlayPause = button
        activateButtonPlayPauseConstraints()
    }
    
    private func configureButtonNext() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "next") {
            button.setImage(image, for: .normal)
            button.setImage(image, for: .highlighted)
        }
        button.addTarget(self, action:#selector(self.buttonNextTapped), for: .touchUpInside)
        self.stackViewButtons?.addArrangedSubview(button)
        self.buttonNext = button
        activateButtonNextConstraints()
    }
    
    private func configureLabelTime() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        self.stackViewMain?.addArrangedSubview(label)
        self.labelTime = label
        activateLabelTimeConstraints()
    }
    
}


//MARK: - Configure UI
extension PlayerViewController {
    
    private func activateStackViewMainConstraints() {
        guard let stackView = stackViewMain else { return }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
//            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 16.0)
        ])
    }
    
    private func activateImageViewCollectionConstraints() {
        guard let imageView = imageViewCollection,
            let stackView = stackViewMain else { return }
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalToConstant: 160)]) //stackView.widthAnchor, multiplier: 1
    }
    
    private func activateLabelNameConstraints() {
        guard let label = labelName else { return }
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 26)])
    }
    
    private func activateLabelArtistConstraints() {
        guard let label = labelArtist else { return }
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    private func activateStackViewButtonsConstraints() {
        guard let label = labelArtist else { return }
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func activateButtonPreviousConstraints() {
        
    }
    
    private func activateButtonPlayPauseConstraints() {
        
    }
    
    private func activateButtonNextConstraints() {
        
    }
    
    private func activateLabelTimeConstraints() {
        guard let label = labelTime else { return }
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    
}

