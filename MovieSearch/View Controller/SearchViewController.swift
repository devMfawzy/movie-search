//
//  ViewController.swift
//  MovieSearch
//
//  Created by Mohamed Fawzy on 4/25/20.
//  Copyright © 2020 fuzzix. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let SearchCellIdentifier = "SearchViewCell"
    var movieSearchPresenter: MovieSearchPresentation?
    
    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.movieSearchPresenter = MovieSearchPresenter(delegate: self)
    }
    
    /**
     setup table view and search bar
     */
    private func setupViews() {
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchCellIdentifier)
        searchBar.setTextFieldBackgroundColor(.white)
        searchBar.becomeFirstResponder()
    }
    
}

// MARK: - Movie Search Delegate

extension SearchViewController: MovieSearchDelegate {
        
    func didGetMovies() {
        self.tableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func didGetEmptyResult() {
        let alertController = alertControllerWith(title: "No Result", message: "Can't find movies with the specified term!")
        self.present(alertController, animated: true)
    }
    
    func didGetError(message: String) {
        let alertController = alertControllerWith(title: "Error", message: message)
        self.present(alertController, animated: true)
    }
    
    private func alertControllerWith(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
    
}

// MARK: - Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        //Encode string for empty character with url query percent
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard !encodedSearchText.isEmpty else {
            return
        }
        movieSearchPresenter?.onSearch(searchTerm: encodedSearchText)
    }
    
    /**
     Extending search bar to status area
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchPresenter?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCellIdentifier, for: indexPath)
        guard let movies = movieSearchPresenter?.items() else {
            return cell
        }
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    
}

// MARK: - Table View Delegate

extension SearchViewController: UITableViewDelegate {
    
    /**
     Checl if reached the last element in the table view, if so, load more items
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let numberOfItems = movieSearchPresenter?.numberOfItems() else {
            return
        }
        let lastItem = numberOfItems - 1
        if indexPath.row == lastItem {
            movieSearchPresenter?.onLoadMore()
        }
    }
    
}

// MARK: - Scroll View Delegate

extension SearchViewController: UIScrollViewDelegate {
    
    /**
     Hide keyboard if scrolled and results exist
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let numberOfItems = movieSearchPresenter?.numberOfItems(), numberOfItems > 0 else {
            return
        }
        self.searchBar.resignFirstResponder()
    }
    
}
