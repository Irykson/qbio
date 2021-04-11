import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension AudioDBArtistDataSource: ArtistDataSource {
    public func getBio(artist: String) throws -> String {
        guard let queryUrl = try? createQueryUrl(artist: artist) else {
            throw QueryError.invalidQueryString
        }

        return try executeQuery(query: queryUrl)
    }

    public func getBioAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) {
        guard let queryUrl = try? createQueryUrl(artist: artist) else {
            resultHandler(nil, QueryError.invalidQueryString)
            return
        }

        executeQueryAsync(query: queryUrl, resultHandler: resultHandler)
    }
}

