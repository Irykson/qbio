import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct qbio_lib  {
    private var baseUrl = URLComponents(
        string: "https://www.theaudiodb.com/api/v1/json/1/search.php")!

    func queryBioOfArtist(artist: String) -> String {
        let queryUrl = (try? createQueryUrl(artist: artist).absoluteString) ?? "No bio found"
        return queryUrl    
    }

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
}
