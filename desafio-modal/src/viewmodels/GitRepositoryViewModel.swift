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
    private let repositoriesCached = BehaviorSubject<[RepositoryDetails]>(value: [])

    let repositories = BehaviorSubject<[RepositoryDetails]>(value: [])
    let filters: BehaviorSubject<Filter>
    let filterName = BehaviorSubject<String>(value: "")

    var openFilterView: (() -> Void)?

    init(gitService: GitService, filterService: FilterService) {
        self.gitService = gitService
        self.filterService = filterService
        self.filters = filterService.filter

        repositoriesCached
            .map {[weak self] in self?.filter(repositories: $0) ?? []}
            .bind(to: repositories)
            .disposed(by: disposeBag)

        filterName
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.updateRepositoryList()
        }
        .disposed(by: disposeBag)

        filters
            .subscribe { [weak self, repositoriesCached, repositories] _ in
                guard
                    let self = self,
                    let repos = try? repositoriesCached.value() else { return }

                let filtered = self.filter(repositories: repos)
                repositories.onNext(filtered)
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
                    self?.repositoriesCached.onNext(list)
                } else {
                   self?.repositoriesCached.onNext([])
                }
            }
            .disposed(by: disposeBag)
    }

    private func updateRepositoryList(searchBy name: String) {
        return gitService.getRepositoriesDetailList(searchBy: name)
            .subscribe {[weak self] res in
                guard !res.isCompleted else { return }
                if let list = res.element {
                    self?.repositoriesCached.onNext(list)
                } else {
                   self?.repositoriesCached.onNext([])
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

    private func filter(repositories: [RepositoryDetails]) -> [RepositoryDetails] {
        var repositories = repositories
        guard let filterOptions = try? filters.value() else { return repositories }

        repositories = repositories.filter {
            return self.filter(repository: $0, by: filterOptions.filters)
        }

        guard let order = filterOptions.order else { return repositories}
        return self.order(by: order, repositories: repositories)
    }

    private func filter(repository: RepositoryDetails, by filters: [FilterButton]) -> Bool {
        return filters.allSatisfy {
            switch $0 {
            case .star:
                return StarsGreaterThanFilter(param: 99).keep(item: repository)
            case .followers:
                return FollowersGreaterThanFilter(param: 100).keep(item: repository)
            case .date:
                let date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                return DateGreaterThanFilter(param: date).keep(item: repository)
            default:
                return true
            }
        }
    }

    private func order(by order: Order, repositories: [RepositoryDetails]) -> [RepositoryDetails] {
        if order == .ASCENDING {
            return repositories.sorted(by: {$0.name < $1.name})
        } else {
            return repositories.sorted(by: {$0.name > $1.name})
        }
    }

}
