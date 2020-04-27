import UIKit

protocol MovieSearchPresentation {
    func onSearch(searchTerm: String)
    func onLoadMore()
    func numberOfItems() -> Int
    func items() -> [Movie]
    func suggestions() -> [String]
    func suggestionsViewHeight() -> CGFloat
}

class MovieSearchPresenter: MovieSearchPresentation {
    
    private var currentPage = 1
    private var totalPages: Int?
    private var searchTerm: String?
    private var movies = [Movie]()
    private var isFetchingData = false
    
    weak var delegate: MovieSearchDelegate?
    
    init(delegate: MovieSearchDelegate?) {
        self.delegate = delegate
    }
    
    /**
     call search movies request and handle error, esponse, call the appropiate delegates
     */
    private func searchMovies(page: Int) {
        guard !isFetchingData else {
            return
        }
        guard let searchTerm = self.searchTerm else {
            return
        }
        self.isFetchingData = true
        delegate?.didStartSearching()
        MovieSearcher.shared.search(searchTerm, page: page) { [weak self] (error, movieSearchResponse) in
            self?.isFetchingData = false
            self?.delegate?.didFinishSearching()
            if let error = error {
                self?.delegate?.didGetError(message: error)
                return
            }
            guard let movieSearchResponse = movieSearchResponse else {
                return
            }
            self?.handleResponse(movieSearchResponse)
        }
    }
    
    /**
     handle response, if first page then replace the movies with the new fetched, if not then append to the existing elements. Call the appropiate delegate according to the response elements.
     */
    private func handleResponse(_ response: MovieSearchResponse) {
        self.currentPage = response.page ?? 1
        if self.currentPage == 1 {
            self.movies.removeAll()
        }
        if let movies = response.results {
            self.movies.append(contentsOf: movies)
        }
        self.totalPages = response.totalPages
        if movies.isEmpty {
            delegate?.didGetEmptyResult()
        } else {
            delegate?.didGetMovies()
            saveSearchTerm()
        }
    }
    
    /**
     Persist search query in suggestions store
     */
    func saveSearchTerm() {
        guard let searchTerm = searchTerm else {
            return
        }
        SuggestionsStore.shared.save(term: searchTerm)
    }
    
    /**
     check if more pages to fetch
     */
    var haveMorePages: Bool {
        guard let totalPages = totalPages else {
            return false
        }
        return totalPages > currentPage
    }
    
    // MARK: - Movie Search View Modeling
    
    func onSearch(searchTerm: String) {
        let page = 1
        self.searchTerm = searchTerm
        self.searchMovies(page: page)
    }
    
    func onLoadMore() {
        guard haveMorePages else {
            return
        }
        let newPage = self.currentPage + 1
        self.searchMovies(page: newPage)
    }
    
    func numberOfItems() -> Int {
        return self.movies.count
    }
    
    func items() -> [Movie] {
        return self.movies
    }
    
    func suggestions() -> [String] {
        return SuggestionsStore.shared.load() ?? []
    }
    
    /**
     Calculate the height of suggestions view according to avaiable items
     */
    func suggestionsViewHeight() -> CGFloat {
        let maxItemsCount = 5
        let rowHeight = 48
        let itemsCount = min(suggestions().count, maxItemsCount)
        return CGFloat(rowHeight) * CGFloat(itemsCount)
    }
    
}
