//
//  BaseCoordinator.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
//    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()
    func start(coordinator child: Coordinator)
    func didFinish(coordinator child: Coordinator)
    func removeAllChildCoordinators()
}

class BaseCoordinator: Coordinator {
    let navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("Coordinator::start should be implemented.")
    }

    func start(coordinator child: Coordinator) {
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }

    func didFinish(coordinator child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }

    func removeAllChildCoordinators() {
        childCoordinators.forEach { $0.removeAllChildCoordinators() }
        childCoordinators.removeAll()
    }
}
