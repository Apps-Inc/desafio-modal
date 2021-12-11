//
//  DetailViewModel.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 09/12/21.
//

import Foundation
import RxSwift

struct DetailViewModel {
    private let disposeBag = DisposeBag()
    var repoImagePath: String!
    var repoNameText: String!
    var starCountText: String!
    var commitsText: String!
    var realeasesText: String!
    var branchsText: String!
    var colaboratorText: String!
    var readmeScrollText = BehaviorSubject<String>(value: "")

    init(gitService: GitService, repository: RepositoryDetails) {
        repoNameText = repository.name
        starCountText = String(repository.stargazersCount)
        commitsText = ""
        realeasesText = ""
        branchsText = ""
        colaboratorText = ""

        gitService.getReadme(fullName: repository.fullName).subscribe { [weak readmeScrollText] result in
            guard let readmeText = try? result.get() else { return }
            readmeScrollText?.onNext(readmeText)
        }
        .disposed(by: disposeBag)

    }
}
