import qbio_lib

extension QBio {
    /// DataSource used to query the bio
    static var artistDataSource: ArtistDataSource?

    func printBio(artist: String) throws {
        guard let artistDataSource = QBio.artistDataSource else {
            throw DependencyError.noArtistDataSource
        }

        let bio = try artistDataSource.getBio(artist: artist)
        print(artist)
        print("--------------------")
        print(bio)

        // print an empty line for better visual separation for multiple artists
        print()
    }

    enum DependencyError: Error {
        case noArtistDataSource
    }
}
