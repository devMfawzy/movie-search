import Foundation

struct MovieSearchResponse: Decodable {
    
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?
    let results: [Movie]?
    
}
