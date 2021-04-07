protocol ArtistDataSource {
    /// Gets a biography of a given `artist`. 
    func getBio(artist: String) -> String
}