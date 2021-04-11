import Foundation

extension AudioDBArtistDataSource {
    private var baseUrl: URLComponents {
        URLComponents(
            string: "https://www.theaudiodb.com/api/v1/json/1/search.php")!
    }

    func getBioByName(artist: String) throws -> String {
        guard let url = try? createQueryUrl(artist: artist) else {
            throw QueryError.invalidQueryString
        }

        return try executeQuery(query: url)
    }

    func getBioByNameAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) {
        guard let url = try? createQueryUrl(artist: artist) else {
            resultHandler(nil, QueryError.invalidQueryString)
            return
        }

        executeQueryAsync(query: url, resultHandler: resultHandler)
    }

    /// Creates a URL with search parameter with the given `artist`
    private func createQueryUrl(artist: String) throws -> URL {
        // create and use a copy to not modify the base url of this struct
        var baseUrlCopy = baseUrl
        let baseUrlItem = URLQueryItem(name: "s", value: artist)
        baseUrlCopy.queryItems = [baseUrlItem]

        if let url = baseUrlCopy.url {
            return url
        } else {
            throw QueryError.invalidQueryString
        }
    }

}

enum QueryError: Error {
    case invalidQueryString
    case noEmptyArtist
}

extension QueryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidQueryString:
            return NSLocalizedString(
                "An invalid query value was passed. Please try another one.", comment: "")
        case .noEmptyArtist:
            return NSLocalizedString("No artist was passed. Empty String was passed.", comment: "")
        }
    }
}
