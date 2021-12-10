//
//  GitService.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import RxSwift

class GitService {
    private let lastId = 0
    let repositoriesCache = BehaviorSubject<Repositories>(value: [])

    func getRepositoriesDetailList(lastId: Int = 0) -> Observable<[RepositoryDetails]> {
        return getRepositoriesList(lastId: lastId)
            .asObservable()
            .flatMap { [weak self] (repos: [Repository]) in
                return Observable.zip(repos[0..<5].map { (repo: Repository) in
                        self!.getRepositoryDetail(repository: repo).asObservable()

                })
            }
    }

    private func getRepositoriesList(lastId: Int = 0) -> Single<Repositories> {
        return Observable.create { observer in
            GitHubApi.Get.repositories(lastId: lastId) { repositories in
                observer.onNext(repositories ?? [])
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    private func getRepositoryDetail(repository: Repository) -> Single<RepositoryDetails> {
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

}
