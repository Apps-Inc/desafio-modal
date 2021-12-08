//
//  FilterCoordinator.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import Foundation
import UIKit

class FilterCoordinator: BaseCoordinator {

    private let filterService: FilterService

    init(navigationController: UINavigationController, filterService: FilterService) {
        self.filterService = filterService
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = FilterViewModel(filterService: filterService)

        let viewController = FilterViewController()
        viewController.viewModel = viewModel
//        self.navigationController.viewControllers.append(viewController)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
