//
//  FilterViewController.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 08/12/21.
//

import UIKit
import RxSwift

class FilterViewController: UIViewController {
    static let identifier = "FilterViewController"
    private let disposeBag = DisposeBag()

    var viewModel: FilterViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
