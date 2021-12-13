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

 struct StarsGreaterThanFilter: Filterable {
    typealias ListItemT = RepositoryDetails
    typealias ParamT = Int

    var param: ParamT

    func keep(item: RepositoryDetails) -> Bool {
        item.stargazersCount > param
    }
}

 struct DateGreaterThanFilter: Filterable {
    typealias ListItemT = RepositoryDetails
    typealias ParamT = Date

    var param: ParamT

    func keep(item: RepositoryDetails) -> Bool {
        item.createdAt > param
    }
}

 struct FollowersGreaterThanFilter: Filterable {
    typealias ListItemT = RepositoryDetails
    typealias ParamT = Int

    var param: ParamT

    func keep(item: RepositoryDetails) -> Bool {
        item.watchers > param
    }
}
