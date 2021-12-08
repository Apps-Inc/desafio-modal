import Foundation

protocol Filterable {
    associatedtype ListItemT
    associatedtype ParamT

    var param: ParamT { get }

    func apply(lst: [ListItemT]) -> [ListItemT]
}
