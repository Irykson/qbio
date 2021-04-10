import XCTest

import qbio_libTests
import qbioTests

var tests = [XCTestCaseEntry]()
tests += qbio_libTests.allTests()
tests += qbioTests.allTests()
XCTMain(tests)
