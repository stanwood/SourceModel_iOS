import XCTest
@testable import SourceModel

final class SourceModelTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SourceModel().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
