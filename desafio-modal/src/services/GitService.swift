//
//  GitService.swift
//  desafio-modal
//
//  Created by VICTOR MOREIRA MELLO on 06/12/21.
//

import Foundation
import RxSwift

protocol GitServiceProtocol {
    func listAllRepository() -> Single<[GitRepositorySummary]>
    func getRepositoryDetail() -> Single<GitRepositoryDetail>
}

class GitService: GitServiceProtocol {
    func listAllRepository() -> Single<[GitRepositorySummary]> {
        return Single.just([
            GitRepositorySummary(name: "Flygondex"),
            GitRepositorySummary(name: "Criptoview")
        ])
    }

    func getRepositoryDetail() -> Single<GitRepositoryDetail> {
        return Single.just(
            GitRepositoryDetail(name: "Flygondex")
        )
    }

}
