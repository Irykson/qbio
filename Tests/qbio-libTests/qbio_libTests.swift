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

    func test_query_for_bio() {
        XCTAssertGreaterThan(artistDataSource.getBio(artist: "Rise Against").count, 0)
    }

    static var allTests = [
        ("test_query_for_bio", test_query_for_bio)
    ]
}
