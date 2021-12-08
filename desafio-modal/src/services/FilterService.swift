//
//  FilterService.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import Foundation
import RxSwift

class FilterService {
    let filter = BehaviorSubject<Filter>(value: Filter())
}
