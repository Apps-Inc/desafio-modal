import Foundation

protocol Filterable {
    associatedtype ListItemT
    associatedtype ParamT

    var param: ParamT { get }

    func apply(lst: [ListItemT]) -> [ListItemT]
}

extension Array where Element: Filterable {
    typealias ListItemT = Element.ListItemT

    func apply(lst: [ListItemT]) -> [ListItemT] {
        self.reduce(lst) { partial, nextFilter in
            nextFilter.apply(lst: partial)
        }
    }
}
