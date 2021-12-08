//
//  FilterViewController.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 07/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: UIViewController {
    private let disposeBag = DisposeBag()

    var switchA: UISwitch!
    var switchB: UISwitch!
    var button: UIButton!

    var viewModel: FilterViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        switchA = UISwitch()
        switchA.translatesAutoresizingMaskIntoConstraints = false

        switchB = UISwitch()
        switchB.translatesAutoresizingMaskIntoConstraints = false

        button = UIButton()
        button.setTitle("save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .gray

        view.addSubview(switchA)
        view.addSubview(switchB)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            switchA.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            switchB.topAnchor.constraint(equalTo: switchA.bottomAnchor, constant: 10),
            button.topAnchor.constraint(equalTo: switchB.bottomAnchor, constant: 10)
        ])

        setupBinds()
    }

    func setupBinds() {
        guard let viewModel = viewModel else { return }

        viewModel.filterA.bind(to: switchA.rx.isOn).disposed(by: disposeBag)
        viewModel.filterB.bind(to: switchB.rx.isOn).disposed(by: disposeBag)

        switchA.rx.isOn
            .bind(to: viewModel.filterA)
            .disposed(by: disposeBag)

        switchB.rx.isOn
            .bind(to: viewModel.filterB)
            .disposed(by: disposeBag)

        button.rx.tap
            .bind {
                viewModel.apply()
            }
            .disposed(by: disposeBag)
    }
}
