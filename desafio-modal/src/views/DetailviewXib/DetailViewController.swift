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

    @IBOutlet weak var detailUI: DetailView!

    var viewModel: DetailViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detalhe"

        loadData()
    }

    func loadData() {
        guard let viewModel = viewModel else { return }

        detailUI.repoNameLabel.text = viewModel.repoNameText
        detailUI.starCountLabel.text = viewModel.starCountText

        viewModel.readmeScrollText.bind(to: detailUI.readmeTextArea.rx.text)
            .disposed(by: disposeBag)
        viewModel.commitsText.bind(to: detailUI.commitsLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.branchsText.bind(to: detailUI.branchsLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
