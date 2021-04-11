import ArgumentParser
import qbio_lib

struct QBio: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A simple utility to query (your favorites) artist's bio.",
        version: "0.0.1"
    )

    @Argument(
        help: "The artists to query. Multiple artists can be queried by separating with whitespace."
    )
    var artists: [String]
}
