//
//  FilterViewModel.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import Foundation
import RxSwift

protocol FilterDelegate: AnyObject {
    func onFilterApply()
}

enum Order {
    case DESCENDING
    case ASCENDING
}

class FilterViewModel {
    private let filterService: FilterService

//    let startsSelected: Bool
//    let followersSelected: Bool
//    let dateSelected: Bool
//    let orderSelected: Order?
    var filter: Filter

    init(filterService: FilterService) {
        self.filterService = filterService

        if let filterValue = try? filterService.filter.value() {
            filter = filterValue

//            startsSelected = filterValue.filters.contains(.star)
//            followersSelected = filterValue.filters.contains(.followers)
//            dateSelected = filterValue.filters.contains(.date)
//
//            orderSelected = filterValue.order
        } else {
            filter = Filter()
//            startsSelected = false
//            followersSelected = false
//            dateSelected = false
//            orderSelected = nil
        }
    }

    func apply(filters: [FilterButton], order: Order?) {

        print("selec", filters)
        let filterOptions = Filter(filters: filters, order: order)
        filterService.filter.onNext(filterOptions)
    }
}
