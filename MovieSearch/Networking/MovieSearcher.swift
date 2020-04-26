import Foundation
import Alamofire

class MovieSearcher {
    
    static let shared = MovieSearcher()
    private init() {}
    
    typealias Result = (String?, MovieSearchResponse?) -> Void
    
    /**
     Build the request URL
     - Parameter term: the search term (String)
     - Parameter page: the page of resource
     - Returns: the url of the request as string
     */
    private func requestURLStringOf(term: String, page: Int) -> String {
        return "\(Constants.baseURL)?api_key=\(Constants.APIKey)&query=\(term)&page=\(page)"
    }
    
    /**
     Perform search request
     - Parameter term: the search term (String)
     - Parameter page: the page of resource
     - Parameter completion: the block of code to be called appon completion
     */
    func search(_ term: String, page: Int, completion: @escaping Result) {
        let requestURLString = requestURLStringOf(term: term, page: page)
        Alamofire.request(requestURLString).responseData { [weak self] (responseData) in
            guard let self = self else {
                return
            }
            if let error = responseData.error {
                completion(error.localizedDescription, .none)
            } else if let data = responseData.data {
                guard let movieSearchResponse = self.decodeSearchResult(from: data) else {
                    fatalError("Error Decoding Movie Search Response")
                }
                completion(.none, movieSearchResponse)
            }
        }
    }
    
    /**
     Decode result data to MovieSearchResponse or nil
     - Parameter data: the Data to be decoded
     - Returns: tthe MovieSearchResponse or nil
     */
    private func decodeSearchResult(from data: Data) -> MovieSearchResponse? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(MovieSearchResponse.self, from: data)
    }
    
}
