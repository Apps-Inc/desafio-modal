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
//
// struct StargazersGreaterThanFilter: Filterable {
//    typealias ListItemT = RepositoryDetails
//    typealias ParamT = Int
//
////    var title: String {
////        get {
////            "ESTRELAS"
////        }
////    }
//
//    var param: ParamT
//
//    func apply(lst: [ListItemT]) -> [ListItemT] {
//        lst.filter { $0.stargazersCount > param }
//    }
// }
//
// struct WatchersGreaterThanFilter: Filterable {
//    typealias ListItemT = RepositoryDetails
//    typealias ParamT = Int
//
////    var title: String {
////        get {
////            "SEGUIDORES"
////        }
////    }
//
//    var param: ParamT
//
//    func apply(lst: [ListItemT]) -> [ListItemT] {
//        lst.filter { $0.stargazersCount > param }
//    }
// }
//
// private struct DateGreaterThanFilter: Filterable {
//    typealias ListItemT = RepositoryDetails
//    typealias ParamT = Date
//
////    var title: String {
////        get {
////            "DATA"
////        }
////    }
//
//    var param: ParamT
//
//    func apply(lst: [ListItemT]) -> [ListItemT] {
//        lst.filter { $0.createdAt > param }
//    }
// }
