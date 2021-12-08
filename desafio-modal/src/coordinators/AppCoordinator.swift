//
//  AppCoordinator.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {

    let window: UIWindow
    let gitService: GitService
    let filterService: FilterService

    init(navigationController: UINavigationController, window: UIWindow, gitService: GitService, filterService: FilterService) {
        self.window = window
        self.gitService = gitService
        self.filterService = filterService
        super.init(navigationController: navigationController)
    }

    override func start() {
        let gitRepositoryCoordinator = ListCoordinator(navigationController: navigationController,
                                                                gitService: gitService,
                                                                filterService: filterService)
        start(coordinator: gitRepositoryCoordinator)
    }
}
