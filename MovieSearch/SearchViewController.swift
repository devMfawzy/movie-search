//
//  ViewController.swift
//  MovieSearch
//
//  Created by Mohamed Fawzy on 4/25/20.
//  Copyright © 2020 fuzzix. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /**
     setup table view and search bar
     */
    private func setupViews() {
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        searchBar.setTextFieldBackgroundColor(.white)
        searchBar.becomeFirstResponder()
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - Hanlde Search Button Click
    }
    
    /**
     Extending search bar to status area
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
