//
//  GitRepositoryController.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import UIKit

class ListCoordinator: BaseCoordinator {

    private let gitService: GitService
    private let filterService: FilterService

    init(navigationController: UINavigationController, gitService: GitService, filterService: FilterService) {
        self.gitService = gitService
        self.filterService = filterService
        super.init(navigationController: navigationController)
    }

    override func start() {
        let gitCollectionViewController = ViewController(nibName: ViewController.indentifier, bundle: nil)

        let viewModel = GitRepositoryViewModel(gitService: gitService)
        gitCollectionViewController.viewModel = viewModel

        self.navigationController.viewControllers = [gitCollectionViewController]
        self.navigationController.isNavigationBarHidden = false

        viewModel.openFilterView = { [weak navigationController, weak filterService] in
//            guard let `self` = self else { return }
            guard
                let navigationController = navigationController,
                let filterService = filterService
            else {
                return
            }
            let filterCoordinator = FilterCoordinator(navigationController: navigationController, filterService: filterService)
            filterCoordinator.start()
        }
    }
}
