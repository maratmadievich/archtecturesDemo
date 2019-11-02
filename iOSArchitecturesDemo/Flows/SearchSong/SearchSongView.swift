//
//  SearchSongViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchSongViewProtocol: class {
    func updateTableView()
    func updateSearchBar(_ resignFirstResponder: Bool)
    func updateThrobber(isShow: Bool)
    func show(error: Error)
    func updateEmptyResults(isHide: Bool)
}

class SearchSongView: UIViewController {
    
    private var presenter: SearchSongPresenterProtocol!
    private let cellIdentifier: String = "SongCell"
    
    private let navigationTitle = "Find Song"
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    override func loadView() {
        super.loadView()
        configurePresenter()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

//MARK: - SearchSongViewProtocol
extension SearchSongView: SearchSongViewProtocol {
    
    internal func updateTableView() {
        self.searchView.tableView.reloadData()
    }
    
    internal func updateSearchBar(_ resignFirstResponder: Bool) {
        self.searchView.searchBar.resignFirstResponder()
    }
    
    internal func updateThrobber(isShow: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isShow
    }
    
    internal func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func updateEmptyResults(isHide: Bool) {
        self.searchView.emptyResultView.isHidden = isHide
    }
    
}

//MARK: - UITableViewDataSource
extension SearchSongView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongCell {
            cell.presenter = self.presenter?.getCellPresenter(for: indexPath.row)
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchSongView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didEntered(query: searchBar.text)
    }
}

//MARK: - UITableViewDelegate
extension SearchSongView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let item = self.searchResults[indexPath.row]
//        item.didSelect(in: self)
    }
}

extension SearchSongView {
    
    private func configurePresenter() {
        self.presenter = SearchSongPresenter(view: self)
    }
    
}

//MARK: - configure UI
extension SearchSongView {
    
    private func configureUI() {
        configureNavigation()
        configureSearchView()
        configureTableView()
    }
    
    private func configureNavigation() {
        self.navigationController?
            .navigationBar.prefersLargeTitles = true
        self.navigationItem.title = navigationTitle
    }
    
    private func configureSearchView() {
         self.searchView.searchBar.delegate = self
    }
    
    private func configureTableView() {
        self.searchView.tableView.register(SongCell.self, forCellReuseIdentifier: cellIdentifier)
        self.searchView.tableView.isHidden = false
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
    }
    
}
