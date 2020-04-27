import Foundation

struct Movie: Decodable {
    
    let posterPath: String?
    let title: String?
    let releaseDate: String?
    let overview: String?
    
}

extension Movie {
    
    var poster: URL? {
        guard let posterPath = posterPath else {
            return .none
        }
        let urlString = "\(Constants.imagesbase)\(posterPath)"
        return URL(string: urlString)
    }
    
}
