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
    private let repositories = BehaviorSubject<Repositories>(value: [])

    let allRepositories: Observable<Repositories>
    let filters: BehaviorSubject<Filter>
    let filterName = BehaviorSubject<String>(value: "")

    var openFilterView: (() -> Void)?

    init(gitService: GitService, filterService: FilterService) {
        self.gitService = gitService
        self.filterService = filterService

        self.allRepositories = repositories.asObservable()
        self.filters = filterService.filter// .asObservable()
    }

    func updateRepositoryList() {
        gitService.repositories()
            .subscribe {[weak self] res in
                if let list = try? res.get() {
                    self?.repositories.onNext(list)
                } else {
                    self?.repositories.onNext([])
                }
            }
            .disposed(by: disposeBag)
    }

    func fetchNextPage() {
    }

    func removeFilterItem(item: FilterButton) {
//        filters.onNext()
        guard let filterOptions = try? filters.value() else { return }

        let selected = filterOptions.filters.filter { $0 != item }
        let newFilter = Filter(filters: selected, order: filterOptions.order)
        filters.onNext(newFilter)
    }
}
