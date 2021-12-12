//
//  GitCollectionViewModel.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import RxSwift

protocol GitRepositoryDelegate: AnyObject {
    func openFilterView()
}

class GitRepositoryViewModel {

    private let disposeBag = DisposeBag()
    private let gitService: GitService
    private let filterService: FilterService
    private let repositories = BehaviorSubject<[RepositoryDetails]>(value: [])

    let allRepositories: Observable<[RepositoryDetails]>
    let filters: BehaviorSubject<Filter>
    let filterName = BehaviorSubject<String>(value: "")

    var openFilterView: (() -> Void)?

    init(gitService: GitService, filterService: FilterService) {
        self.gitService = gitService
        self.filterService = filterService
        self.filters = filterService.filter

        self.allRepositories = repositories.asObservable()

        filterName
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.updateRepositoryList()
        }
        .disposed(by: disposeBag)
    }

    func updateRepositoryList() {
        if let searchByName = try? filterName.value(),
              !searchByName.isEmpty {
            updateRepositoryList(searchBy: searchByName)
        } else {
            updateRepositoryListWithoutSearch()
        }
    }

    private func updateRepositoryListWithoutSearch() {
        gitService.getRepositoriesDetailList()
            .subscribe {[weak self] res in
                guard !res.isCompleted else { return }
                if let list = res.element {
                    self?.repositories.onNext(list)
                } else {
                   self?.repositories.onNext([])
                }
            }
            .disposed(by: disposeBag)
    }

    private func updateRepositoryList(searchBy name: String) {
        return gitService.getRepositoriesDetailList(searchBy: name)
            .subscribe {[weak self] res in
                guard !res.isCompleted else { return }
                if let list = res.element {
                    self?.repositories.onNext(list)
                } else {
                   self?.repositories.onNext([])
                }
            }
            .disposed(by: disposeBag)
    }

    func removeFilterItem(item: FilterButton) {
        guard let filterOptions = try? filters.value() else { return }

        if item == .order {
            let newFilter = Filter(filters: filterOptions.filters, order: nil)
            filters.onNext(newFilter)
        } else {
            let selected = filterOptions.filters.filter { $0 != item }
            let newFilter = Filter(filters: selected, order: filterOptions.order)
            filters.onNext(newFilter)
        }
    }
}
