//
//  DetailViewModel.swift
//  desafio-modal
//
//  Created by FRANCISCO SAMUEL DA SILVA MARTINS on 09/12/21.
//

import Foundation
import RxSwift
import UIKit

class DetailViewModel {
    private let disposeBag = DisposeBag()
    var repoImagePath: URL?
    var image = BehaviorSubject<UIImage?>(value: nil)
    var repoNameText: String
    var starCountText: String
    var commitsText = BehaviorSubject<String>(value: "")
    var realeasesText = BehaviorSubject<String>(value: "")
    var branchsText = BehaviorSubject<String>(value: "")
    var colaboratorText = BehaviorSubject<String>(value: "")
    var readmeScrollText = BehaviorSubject<String>(value: "")

    init(gitService: GitService, repository: RepositoryDetails) {
        repoNameText = repository.name
        starCountText = String(repository.stargazersCount)
        repoImagePath = repository.avatarUrl

        gitService.getReadme(fullName: repository.fullName).subscribe { [weak readmeScrollText] result in
            guard let readmeText = try? result.get() else { return }
            readmeScrollText?.onNext(readmeText)
        }
        .disposed(by: disposeBag)

        gitService.getBranchesCount(fullName: repository.fullName).subscribe { [weak branchsText] result in
            guard let count = try? result.get() else { return }
            branchsText?.onNext(String(count))
        }
        .disposed(by: disposeBag)

        gitService.getCommitCount(fullName: repository.fullName).subscribe { [weak commitsText] result in
            guard let count = try? result.get() else { return }
            commitsText?.onNext(String(count))
        }
        .disposed(by: disposeBag)

        DispatchQueue.global(qos: .userInteractive).async { [weak image, repoImagePath] in
            if
                let imageUrl = repoImagePath,
                let data = try? Data(contentsOf: imageUrl)
            {
                image?.onNext(UIImage(data: data))
            }
        }
    }
}
