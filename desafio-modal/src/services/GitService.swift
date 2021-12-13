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
                return Observable.zip(repos[0..<10].map { (repo: Repository) in
                        self!.getRepositoryDetail(repository: repo).asObservable()

                })
            }
    }

    func getRepositoriesDetailList(searchBy name: String) -> Observable<[RepositoryDetails]> {
        return Observable.create { observer in
            GitHubApi.Get.search(query: name) { detail in
                if let detail = detail {
                    observer.onNext(detail.items)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }
            return Disposables.create()
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

    func getReadme(fullName: String) -> Single<String> {
        return Observable.create { observer in
            GitHubApi.Get.readme(fullName: fullName) { result in
                if let readme = result {
                    observer.onNext(readme)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    func getCommitCount(fullName: String) -> Single<Int> {
        Observable.create { observer in
            GitHubApi.Get.countCommits(fullName: fullName) { result in
                if let readme = result {
                    observer.onNext(readme)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    func getBranchesCount(fullName: String) -> Single<Int> {
        Observable.create { observer in
            GitHubApi.Get.countBranches(fullName: fullName) { result in
                if let readme = result {
                    observer.onNext(readme)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    func getContributors(fullName: String) -> Single<Int> {
        Observable.create { observer in
            GitHubApi.Get.countContributors(fullName: fullName) { result in
                if let contributors = result {
                    observer.onNext(contributors)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

    func getReleases(fullName: String) -> Single<Int> {
        Observable.create { observer in
            GitHubApi.Get.countReleases(fullName: fullName) { result in
                if let releases = result {
                    observer.onNext(releases)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSingle()
    }

}
