import UIKit

class SearchViewController: UIViewController {
    
    private let SearchCellIdentifier = "SearchViewCell"
    private let SuggestionsCellIdentifier = "SuggestionsViewCell"
    
    var movieSearchPresenter: MovieSearchPresentation?
    
    // MARK: - IBOutlets

    @IBOutlet private weak var searchResultsTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var suggestionsTableView: UITableView!
    @IBOutlet private weak var suggestionViewHeight: NSLayoutConstraint!
    
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
        searchResultsTableView.tableFooterView = UIView()
        searchResultsTableView.register(UINib(nibName: SearchCellIdentifier, bundle: nil), forCellReuseIdentifier: SearchCellIdentifier)
        searchBar.setTextFieldBackgroundColor(.white)
        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: SuggestionsCellIdentifier)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        searchBar.becomeFirstResponder()
    }
    
}

// MARK: - Movie Search Delegate

extension SearchViewController: MovieSearchDelegate {
        
    func didGetMovies() {
        self.searchResultsTableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func didGetEmptyResult() {
        let alertController = alertControllerWith(title: "No Result".localized, message: "Can't find movies with the specified term!".localized)
        self.present(alertController, animated: true)
    }
    
    func didGetError(message: String) {
        let alertController = alertControllerWith(title: "Error".localized, message: message)
        self.present(alertController, animated: true)
    }
    
    func didStartSearching() {
        activityIndicator.startAnimating()
    }
    
    func didFinishSearching() {
        activityIndicator.stopAnimating()
    }
    
    private func alertControllerWith(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default)
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
        suggestionsTableView.isHidden = true
        movieSearchPresenter?.onSearch(searchTerm: encodedSearchText)
    }
    
    /**
     Extending search bar to status area
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    /**
     Show saved suggestions and set the hight of the suggestions table view
     */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        suggestionsTableView.reloadData()
        let height = movieSearchPresenter?.suggestionsViewHeight() ?? 0.0
        suggestionViewHeight.constant = height
        suggestionsTableView.isHidden = false
    }
    
}

// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfItems: Int?
        if tableView == searchResultsTableView {
            numberOfItems = movieSearchPresenter?.numberOfItems()
        } else {
            numberOfItems = movieSearchPresenter?.suggestions().count
        }
        return numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == searchResultsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: SearchCellIdentifier, for: indexPath)
            guard let movies = movieSearchPresenter?.items() else {
                return cell
            }
            if let cell = cell as? SearchViewCell {
                let movie = movies[indexPath.row]
                cell.configureWith(movie)
            }
            cell.selectionStyle = .none
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: SuggestionsCellIdentifier, for: indexPath)
            let suggestions = movieSearchPresenter?.suggestions()
            let suggestion = suggestions?[indexPath.row]
            cell.textLabel?.text = suggestion
        }
        return cell
    }
    
}

// MARK: - Table View Delegate

extension SearchViewController: UITableViewDelegate {
    
    /**
     Checl if reached the last element in the table view, if so, load more items
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView == searchResultsTableView else {
            return
        }
        guard let numberOfItems = movieSearchPresenter?.numberOfItems() else {
            return
        }
        let lastItem = numberOfItems - 1
        if indexPath.row == lastItem {
            movieSearchPresenter?.onLoadMore()
        }
    }
    
    /**
     Search  movies with the selected suggested term
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == suggestionsTableView else {
            return
        }
        let suggestions = movieSearchPresenter?.suggestions()
        guard let suggestion = suggestions?[indexPath.row] else {
            return
        }
        searchBar.text = suggestion
        suggestionsTableView.isHidden = true
        movieSearchPresenter?.onSearch(searchTerm: suggestion)
    }
    
}

// MARK: - Scroll View Delegate

extension SearchViewController: UIScrollViewDelegate {
    
    /**
     Hide keyboard if scrolled and results exist
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == searchResultsTableView else {
            return
        }
        guard let numberOfItems = movieSearchPresenter?.numberOfItems(), numberOfItems > 0 else {
            return
        }
        self.searchBar.resignFirstResponder()
        self.suggestionsTableView.isHidden = true
    }
    
}
