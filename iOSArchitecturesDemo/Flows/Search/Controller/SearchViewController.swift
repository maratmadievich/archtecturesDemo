//
//  ViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 14.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit



protocol SearchItemProtocol {
    
    static func registerCell(in tableView: UITableView)
    
    func didSelect(in viewController: UIViewController)
    
    func getCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
}


class SearchItemAppAdapter: SearchItemProtocol {
    
    private let app: ITunesApp
    
    init(app: ITunesApp) {
        self.app = app
    }
    
    static func registerCell(in tableView: UITableView) {
        tableView.register(AppCell.self, forCellReuseIdentifier: "AppCell")
    }
    
    func didSelect(in viewController: UIViewController) {
        let appDetaillViewController = AppDetailViewController()
        appDetaillViewController.app = self.app
        viewController.navigationController?.pushViewController(appDetaillViewController, animated: true)
    }
    
    func getCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        guard let cell = dequeuedCell as? AppCell else {
            return dequeuedCell
        }
        let app = self.app
        let cellModel = AppCellModelFactory.cellModel(from: app)
        cell.configure(with: cellModel)
        return cell
    }
    
}

// MARK: -

protocol SearchViewProtocol {
    
    
    func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void )
}

class SearchViewITunesServiceAdapter: SearchViewProtocol {
   
    private let searchService: ITunesSearchService
    
    init(searchService: ITunesSearchService) {
        self.searchService = searchService
    }
    
    func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void ) {
        
        var searchResults: [SearchItemProtocol] = []
        
        self.searchService.getApps(forQuery: query) { result in

            result
                .withValue { apps in

                    for app in apps {
                        let searchItem = SearchItemAppAdapter(app: app)
                        searchResults.append(searchItem)
                    }
                    
                    completion(searchResults, nil)
                }
            .withError {_ in
                    completion(searchResults, nil)
                }
        }
    }
    
}

// MARK: -



final class SearchViewController: UIViewController {
    
    // MARK: - Private Properties
    private let navigationTitle = "Find App"
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private var searchService: SearchViewProtocol = SearchViewITunesServiceAdapter(searchService: ITunesSearchService())
    private var searchResults: [SearchItemProtocol] = []
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    
    static func makeAppSearch()  -> SearchViewController{
        let vc = SearchViewController()
        vc.searchService = SearchViewITunesServiceAdapter(searchService: ITunesSearchService())
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = navigationTitle
        self.searchView.searchBar.delegate = self
        
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.searchView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        SearchItemAppAdapter.registerCell(in: self.searchView.tableView)
        
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    // MARK: - Private
    
    private func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNoResults() {
        self.searchView.emptyResultView.isHidden = false
    }
    
    private func hideNoResults() {
        self.searchView.emptyResultView.isHidden = true
    }
    
    private func requestApps(with query: String) {
        self.throbber(show: true)
        self.searchResults.removeAll()
        self.searchView.tableView.reloadData()
        
        self.searchService.loadData(query: query) { [weak self] (items: [SearchItemProtocol], error: Error?) in
            
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(error: error)
                } else if items.count <= 0 {
                    self?.showNoResults()
                } else {
                    self?.searchResults.append(contentsOf: items)
                    self?.hideNoResults()
                    self?.searchView.tableView.isHidden = false
                    self?.searchView.tableView.reloadData()
                }
            }            
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.searchResults[indexPath.row]
        let cell = item.getCell(in: tableView, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.searchResults[indexPath.row]
        item.didSelect(in: self)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
        self.requestApps(with: query)
    }
}
