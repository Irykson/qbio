import XCTest

@testable import qbio_lib

final class qbio_libTests: XCTestCase {
    var artistDataSource: ArtistDataSource!

    override func setUp() {
        artistDataSource = AudioDBArtistDataSource()
    }

    override func tearDown() {
        artistDataSource = nil
    }

    func test_query_throws_error_if_empty_string() {
        XCTAssertThrowsError(try artistDataSource.getBio(artist: ""))
    }

    func test_query_returns_bio() {
        XCTAssertGreaterThan(try artistDataSource.getBio(artist: "Rise Against").count, 0)
    }

    func test_query_throws_error_if_not_found_artist() {
        var actualError: QueryError? = nil;
        XCTAssertThrowsError(try artistDataSource.getBio(artist: "42 is the answer, not an artist")) { error in
            actualError = error as? QueryError
        }

        XCTAssertEqual(QueryError.artistNotFound, actualError)
    }

    static var allTests = [
        ("test_query_returns_bio", test_query_returns_bio),
        ("test_query_throws_error_if_not_found_artist", test_query_throws_error_if_not_found_artist)
    ]
}
