//
//  Filter.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import Foundation

struct Filter {
    let filtroA: Bool
    let filtroB: Bool

    init() {
        filtroA = false
        filtroB = false
    }

    init(filtroA: Bool, filtroB: Bool) {
        self.filtroA = filtroA
        self.filtroB = filtroB
    }
}
