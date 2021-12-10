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

enum Order: String {
    case DESCENDING = "Decrescente"
    case ASCENDING = "Crescente"
}

class FilterViewModel {
    private let filterService: FilterService

    var filter: Filter

    init(filterService: FilterService) {
        self.filterService = filterService

        if let filterValue = try? filterService.filter.value() {
            filter = filterValue
        } else {
            filter = Filter()
        }
    }

    func apply(filters: [FilterButton], order: Order?) {

        print("selec", filters)
        let filterOptions = Filter(filters: filters, order: order)
        filterService.filter.onNext(filterOptions)
    }
}
