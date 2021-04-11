import qbio_lib

extension QBio {
    mutating func run() throws {
        for artist in artists {
            try printBio(artist: artist)
        }
    }
}
