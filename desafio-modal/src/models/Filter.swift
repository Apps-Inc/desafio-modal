//
//  Filter.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import Foundation

struct Filter {
    let filters: [FilterButton]
    let order: Order?

    init() {
        filters = []
        order = nil
    }

    init(filters: [FilterButton], order: Order?) {
        self.filters = filters
        self.order = order
    }
}
