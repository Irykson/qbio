import XCTest
@testable import qbio_lib

final class qbio_libTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(qbio_lib().getBio(artist: "Rise Against"), "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
