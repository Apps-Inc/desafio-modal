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
    private let repositories = BehaviorSubject<Repositories>(value: [])
    let allRepositories: Observable<Repositories>

    var openFilterView: (() -> Void)?

    init(gitService: GitService) {
        self.gitService = gitService
        self.allRepositories = repositories.asObservable()
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
}
