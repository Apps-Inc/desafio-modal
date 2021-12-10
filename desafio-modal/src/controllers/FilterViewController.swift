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
    @IBOutlet weak var filterUI: SetFilterButtons!

    var viewModel: FilterViewModel?
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func applyFilters(_ sender: Any) {
        var ordem: Order?
        var filtros: [FilterButton] = []

        if filterUI.estrelas.isSelected { filtros.append(.star) }
        if filterUI.seguidores.isSelected { filtros.append(.followers) }
        if filterUI.data.isSelected { filtros.append(.date) }

        if filterUI.crescente.isSelected {
            ordem = .ASCENDING
        } else if filterUI.decrescente.isSelected {
            ordem = .DESCENDING
        }

        aplicar(filtros: filtros, ordem: ordem)
    }

    func aplicar(filtros: [FilterButton], ordem: Order?) {
        viewModel?.apply(filters: filtros, order: ordem)
    }
}
