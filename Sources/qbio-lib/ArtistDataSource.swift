public protocol ArtistDataSource {
    /// Gets a biography of a given `artist`. 
    func getBio(artist: String) throws -> String

    /// Gets a biography of a given `artist` via an asynchronous access.
    func getBioAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) 
}