//
//  DetailViewController.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 09/12/21.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"
    private let disposeBag = DisposeBag()

    var viewModel: DetailViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
