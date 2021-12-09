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
        let viewModel = GitRepositoryViewModel(gitService: gitService, filterService: filterService)
        let gitCollectionViewController = ViewController(nibName: ViewController.identifier, bundle: nil)
        gitCollectionViewController.viewModel = viewModel
        gitCollectionViewController.coordinator = self

        self.navigationController.viewControllers = [gitCollectionViewController]
    }

    func openFilter() {
        let viewModel = FilterViewModel(filterService: filterService)
        let filterViewController = FilterViewController(nibName: FilterViewController.identifier, bundle: nil)
        filterViewController.viewModel = viewModel
        filterViewController.coordinator = self

        self.navigationController.pushViewController(filterViewController, animated: true)
    }

    func openDetails() {

    }
}
