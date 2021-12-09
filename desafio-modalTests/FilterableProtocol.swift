@testable import desafio_modal

import XCTest

class FilterableProtocol: XCTestCase {
    // swiftlint:disable nesting
    private struct IntGreaterThanFilter: Filterable {
        typealias ListItemT = Int
        typealias ParamT = Int

        var param: ParamT

        func keep(item: Int) -> Bool {
            item > param
        }
    }
    // swiftlint:enable nesting

    func testIntFilter() throws {
        // arrange
        let filter = IntGreaterThanFilter.init(param: 3)

        // act
        let filtered = filter.apply(to: [1, 2, 3, 4, 5, 6])

        // assert
        XCTAssertEqual(filtered, [4, 5, 6])
    }

    // swiftlint:disable nesting
    private struct StringLenGreaterThanFilter: Filterable {
        typealias ListItemT = String
        typealias ParamT = Int

        var param: ParamT

        func keep(item: String) -> Bool {
            item.count > param
        }
    }
    // swiftlint:enable nesting

    func testStringLebGreaterThanFilter() throws {
        // arrange
        let filter = StringLenGreaterThanFilter.init(param: 2)

        // act
        let filtered = filter.apply(to: ["1", "12", "123"])

        // assert
        XCTAssertEqual(filtered, ["123"])
    }

    func testMultipleFilters() throws {
        // arrange
        let filters = [
            IntGreaterThanFilter.init(param: 1),
            IntGreaterThanFilter.init(param: 2),
            IntGreaterThanFilter.init(param: 3),
            IntGreaterThanFilter.init(param: 4),
            IntGreaterThanFilter.init(param: 5)
        ]

        // act
        let reduced = filters.applyAll(to: [1, 2, 3, 4, 5, 6])

        // assert
        XCTAssertEqual(reduced, [6])
    }
}
