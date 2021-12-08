//
//  GitService.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import RxSwift

class GitService {
    func repositories(lastId: Int = 0) -> Single<Repositories> {

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

}
