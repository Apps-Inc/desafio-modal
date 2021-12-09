import Foundation

protocol Filterable {
    associatedtype ListItemT
    associatedtype ParamT

    var param: ParamT { get }

    func keep(item: ListItemT) -> Bool
}

extension Filterable {
    func apply(to list: [ListItemT]) -> [ListItemT] {
        list.filter { self.keep(item: $0) }
    }
}

extension Array where Element: Filterable {
    typealias ListItemT = Element.ListItemT

    func applyAll(to list: [ListItemT]) -> [ListItemT] {
        list.filter { element in
            self.allSatisfy { filter in
                filter.keep(item: element)
            }
        }
    }
}
