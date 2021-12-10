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
//    @IBOutlet weak var filterUI: SetFilterButtons!
    @IBOutlet weak var filterUI: SetFilterButtons!

    var viewModel: FilterViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        filterUI.delegate = self

        guard let filter = viewModel?.filter else { return }
        filterUI.estrelas.isSelected = filter.filters.contains(.star)
        filterUI.formatButton(button: filterUI.estrelas)

        filterUI.seguidores.isSelected = filter.filters.contains(.followers)
        filterUI.formatButton(button: filterUI.seguidores)

        filterUI.data.isSelected = filter.filters.contains(.date)
        filterUI.formatButton(button: filterUI.data)

        filterUI.crescente.isSelected = filter.order == .ASCENDING
        filterUI.formatButton(button: filterUI.crescente)

        filterUI.decrescente.isSelected = filter.order == .DESCENDING
        filterUI.formatButton(button: filterUI.decrescente)
    }

}

extension FilterViewController: SetFilterDelegate {
    func aplicar(filtros: [FilterButton], ordem: Order?) {
        viewModel?.apply(filters: filtros, order: ordem)
        navigationController?.dismiss(animated: true)
    }

}
