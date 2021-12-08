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

class FilterViewModel {

    private let filterService: FilterService

    weak var delegate: FilterDelegate?

//    weak var delegate: FilterDelegate?

    let filterA: BehaviorSubject<Bool>// (value: false)
    let filterB: BehaviorSubject<Bool>// (value: false)

    init(filterService: FilterService) {
        self.filterService = filterService

        if let filterValue = try? filterService.filter.value() {
            filterA = BehaviorSubject<Bool>(value: filterValue.filtroA)
            filterB = BehaviorSubject<Bool>(value: filterValue.filtroB)
        } else {
            filterA = BehaviorSubject<Bool>(value: false)
            filterB = BehaviorSubject<Bool>(value: false)
        }

        filterA.subscribe { res in
            if let val = res.element {
                print("val1", val)
            }
        }

        filterService.filter.subscribe { res in
            if let val = res.element {
                print("filtro", val)
            }
        }
    }

    func apply() {
        guard
            let filtroA = try? filterA.value(),
            let filtroB = try? filterB.value() else { return }

        let filter = Filter(filtroA: filtroA, filtroB: filtroB)
        filterService.filter.onNext(filter)
        delegate?.onFilterApply()
    }
}
