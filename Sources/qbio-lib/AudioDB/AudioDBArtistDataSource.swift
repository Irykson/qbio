import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

/// Implementation of `ArtistDataSource` with [The AudioDB](https://theaudiodb.com/) as the underlying provider.
public struct AudioDBArtistDataSource: ArtistDataSource {
    public init() {}
    
    public func getBio(artist: String) throws -> String {
        return try getBioByName(artist: artist)
    }

    public func getBioAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) {
        getBioByNameAsync(artist: artist, resultHandler: resultHandler)
    }
}
