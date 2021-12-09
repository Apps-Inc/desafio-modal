//
//  GitService.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import RxSwift

struct RepositoryItem {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String
    let url: String
    let estrelas: Int
//    let seguidores: Int
//    let data: Date

    init(_ repository: Repository, estrelas: Int) {
        id = repository.id
        name = repository.name
        fullName = repository.fullName
        htmlUrl = repository.htmlUrl
        url = repository.url
        self.estrelas = estrelas
    }
}

class GitService {
    private let lastId = 0
    let repositoriesCache = BehaviorSubject<Repositories>(value: [])

    func test(lastId: Int = 0) -> Single<[RepositoryItem]> {

        return repositories(lastId: lastId)
            .asObservable()
            .flatMap { [weak self] repo in
                return Observable.zip(repo[0..<5].map {self!.getRepositoryItem(repository: $0) })
            }
            .asSingle()

    }

    func repositories(lastId: Int = 0) -> Single<Repositories> {

        return getRepositories(lastId: lastId)
    }

    private func getRepositories(lastId: Int = 0) -> Single<Repositories> {

        return Observable.create { observer in
            GitHubApi.Get.repositories(lastId: lastId) { repositories in
                observer.onNext(repositories ?? [])
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    func getRepositoryDetail() -> Single<GitRepositoryDetail> {
        return Single.just(
            GitRepositoryDetail(name: "Flygondex")
        )
    }

    func getRepositoryDetail2(repository: Repository) -> Single<RepositoryDetails> {
        return Observable.create { observer in
            GitHubApi.Get.repositoryDetails(fullName: repository.fullName) { detail in
                if let detail = detail {
                    observer.onNext(detail)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
        .asSingle()
    }

    func getRepositoryItem(repository: Repository) -> Observable<RepositoryItem> {
        return getRepositoryDetail2(repository: repository)
            .map { detail in
                RepositoryItem(repository, estrelas: detail.stargazersCount)

            }
            .asObservable()
    }

}
