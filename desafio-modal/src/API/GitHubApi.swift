import Foundation

struct GitHubApi {
    // Para os que estiverem com problemas em acessar a API, basta setar isso
    // para true por padrão, mas lembre de não comitar essa mudança.
    //
    // A forma antiga (usando a flag MOCK_API_RESPONSES) afeta todos de qualquer
    // forma, então e mais facil manter esse setting nesse arquivo.
    //
    // Precisa continuar como static var por causa dos testes.
    static var useMockedResponses: Bool = {
        let testing = CommandLine.arguments.contains("--uitesting")
        if testing { print("WARNING: using mocked data") }

        return testing
    }()

    static let baseUrl = "https://api.github.com/"

    struct Get {
        static func repositories(
            lastId: Int = 0,
            completionHandler: @escaping (Repositories?) -> Void
        ) { if useMockedResponses {
            completionHandler(Repositories(decode(
                as: RepositoriesResponseDto.self,
                data: RepositoriesResponseDto.dataMock
            )!))
        } else {
            let url = baseUrl + String(
                format: "repositories?since=%d",
                lastId
            )

            getDecoded(as: RepositoriesResponseDto.self, from: url) { dto in
                completionHandler(dto == nil ? nil : Repositories(dto!))
            }
        }}

        static func repositoryDetails(
            fullName: String,
            completionHandler: @escaping (RepositoryDetails?) -> Void
        ) { if useMockedResponses {
            let dto = decodeMock(for: RepositoryDetailsResponseDto.self)!
            completionHandler(RepositoryDetails(dto))
        } else {
            let url = baseUrl + String(
                format: "repos/%@",
                fullName
            )

            getDecoded(as: RepositoryDetailsResponseDto.self, from: url) { dto in
                completionHandler(dto == nil
                    ? nil
                    : RepositoryDetails(dto!)
                )
            }
        }}

        static func repositoryDetails(
            owner: String,
            repo: String,
            completionHandler: @escaping (RepositoryDetails?) -> Void
        ) {
            repositoryDetails(fullName: "\(owner)/\(repo)", completionHandler: completionHandler)
        }

        static func readme(
            fullName: String,
            completionHandler: @escaping (String?) -> Void
        ) { if useMockedResponses {
            completionHandler(try? String(contentsOf: Bundle.main.url(
                forResource: "repository-readme-mock",
                withExtension: "md"
            )!))
        } else {
            let url = baseUrl + String(
                format: "repos/%@/readme",
                fullName
            )

            getDecoded(as: RepositoryReadmeResponseDto.self, from: url) { dto in
                guard
                    let downloadUrl = dto?.downloadUrl,
                    let downloadUrl = URL(string: downloadUrl)
                else {
                    completionHandler(nil)
                    return
                }

                get(from: downloadUrl) { data, _ in
                    completionHandler(String(data: data, encoding: .utf8))
                }
            }
        }}

        static func readme(
            owner: String,
            repo: String,
            completionHandler: @escaping (String?) -> Void
        ) {
            readme(fullName: "\(owner)/\(repo)", completionHandler: completionHandler)
        }

        static let maxBranchesPerRequest = 100 // API restriction

        private static func countPagedBranches(
            fullName: String,
            itensPerPage: Int = maxBranchesPerRequest,
            pageNum: Int = 1,
            previousCount: Int = 0,
            completionHandler: @escaping (Int?) -> Void
        ) {
            let url = baseUrl + String(
                format: "repos/%@/branches?per_page=%d&page=%d",
                fullName,
                itensPerPage,
                pageNum
            )

            getDecoded(as: RepositoryBranchesResponseDto.self, from: url) { dto in
                guard let count = dto?.count else {
                    completionHandler(nil)
                    return
                }

                let currentCount = previousCount + count

                if count == itensPerPage {
                    countPagedBranches(
                        fullName: fullName,
                        itensPerPage: itensPerPage,
                        pageNum: pageNum + 1,
                        previousCount: currentCount,
                        completionHandler: completionHandler
                    )
                } else {
                    completionHandler(currentCount)
                }
            }
        }

        static func countBranches(
            fullName: String,
            completionHandler: @escaping (Int?) -> Void
        ) { if useMockedResponses {
            completionHandler(decode(
                as: RepositoryBranchesResponseDto.self,
                data: RepositoryBranchesResponseDto.dataMock
            )?.count)
        } else {
            countPagedBranches(fullName: fullName, completionHandler: completionHandler)
        }}

        static func countBranches(
            owner: String,
            repo: String,
            completionHandler: @escaping (Int?) -> Void
        ) {
            countBranches(fullName: "\(owner)/\(repo)", completionHandler: completionHandler)
        }

        static func countCommits(
            fullName: String,
            completionHandler: @escaping (Int?) -> Void
        ) { if useMockedResponses {
            completionHandler(decode(
                as: RepositoryContributorsResponseDto.self,
                data: RepositoryContributorsResponseDto.dataMock
            )?.reduce(0, { partialResult, next in
                partialResult + next.total
            }))
        } else {
            let url = baseUrl + String(
                format: "repos/%@/stats/contributors",
                fullName
            )

            getDecoded(as: RepositoryContributorsResponseDto.self, from: url) { decoded in
                completionHandler(decoded?.reduce(0, { partialResult, next in
                    partialResult + next.total
                }))
            }
        }}

        static func countCommits(
            owner: String,
            repo: String,
            completionHandler: @escaping (Int?) -> Void
        ) {
            countCommits(fullName: "\(owner)/\(repo)", completionHandler: completionHandler)
        }

        // API limit
        static let maxItemsPerPage = 100

        static func search(
            query: String,
            sort: ApiSort? = nil,
            order: ApiOrder? = nil,
            perPage: Int = maxItemsPerPage,
            page: Int = 1,
            completionHandler: @escaping (GitHubSearchResults?) -> Void
        ) { if useMockedResponses {
            let dto = decodeMock(for: GitHubSearchResposeDto.self)!
            completionHandler(GitHubSearchResults(dto, page: page))
        } else {
            let url = baseUrl + "search/repositories" +
                "?q=\(query)" +
                (sort == nil ? "" : "&sort=\(sort!.queryParam)") +
                (order == nil ? "" : "&order=\(order!.queryParam)") +
                "&per_page=\(perPage)" +
                "&page=\(page)"

            getDecoded(as: GitHubSearchResposeDto.self, from: url) { decoded in
                guard let decoded = decoded else {
                    completionHandler(nil)
                    return
                }

                completionHandler(GitHubSearchResults(decoded, page: page))
            }
        }}
    }
}

private func decodeMock<T: DataMockable>(for type: T.Type) -> T? {
    guard let decoded = decode(as: T.self, data: T.dataMock) else {
        print("Got nil while decoding mock for type \(T.self)")
        return nil
    }

    return decoded
}

private func getDecoded<T: Decodable>(
    as type: T.Type,
    from url: String,
    onComplete: @escaping (T?) -> Void
) {
    get(from: URL(string: url)!) { data, _ in
        guard let decodedData = decode(as: T.self, data: data) else {
            print("Got null decoded data when decoding type \(T.self)")
            onComplete(nil)
            return
        }

        onComplete(decodedData)
    }
}

private func get(from url: URL, onComplete: @escaping (Data, URLResponse?) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

    let requestTask = URLSession.shared.dataTask(with: request) { (data, response, err) in
        guard err == nil else {
            print("Got an error: \(err!)")
            return
        }

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            print("Could not extract status code")
            return
        }

        guard statusCode == 200 else {
            // TODO: Also treat 304 Not Modified case?

            print("Got status \(statusCode)")
            return
        }

        guard let data = data else {
            print("Got nil data")
            return
        }

        onComplete(data, response)
    }

    requestTask.resume()
}

private func decode<T: Decodable>(as type: T.Type, data: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let decodedData = try? decoder.decode(type, from: data) else {
        print("Error decoding data for type \(type)")
        print("- data: \(data)")
        print("- stringified data: \(String(data: data, encoding: .utf8) ?? "no data")")

        return nil
    }

    return decodedData
}
