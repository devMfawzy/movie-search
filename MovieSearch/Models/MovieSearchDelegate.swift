import Foundation

protocol MovieSearchDelegate: class {
    
    /**
     A delegate methos to be called when receive new movies
     */
    func didGetMovies()
    
    /**
     A delegate methos to be called when receive empty result
     */
    func didGetEmptyResult()
    
    /**
     A delegate methos to be called when receive an error
     */
    func didGetError(message: String)
    
    /**
     A delegate methos to be called when  starting fetching data
     */
    func didStartSearching()
    
    /**
     A delegate methos to be called when finish fetching data
     */
    func didFinishSearching()

    
}
