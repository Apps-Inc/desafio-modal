import Foundation

struct GitHubApi {
    // Para os que estiverem com problemas em acessar a API:
    //
    // 1. clicar em desafio-modal à esquerda
    // 2. selecionem o target "desafio-modal"
    // 3. pesquisar por "other swift flags"
    // 4. em Debug, adicione "-D MOCK_API_RESPONSES"
    static var useMockedResponses: Bool = {
        #if MOCK_API_RESPONSES
        return true
        #else
        return false
        #endif
    }()

    static let baseUrl = "https://api.github.com/"

    struct Get {
        static func repositories(
            lastId: Int = 0,
            completionHandler: @escaping (Repositories) -> Void
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
                completionHandler(Repositories(dto))
            }
        }}

        static func repositoryDetails(
            fullName: String,
            completionHandler: @escaping (RepositoryDetails) -> Void
        ) { if useMockedResponses {
            let dto = decodeMock(for: RepositoryDetailsResponseDto.self)!
            completionHandler(RepositoryDetails(dto)!)
        } else {
            let url = baseUrl + String(
                format: "repos/%@",
                fullName
            )

            getDecoded(as: RepositoryDetailsResponseDto.self, from: url) { dto in
                completionHandler(RepositoryDetails(dto)!)
            }
        }}

        static func repositoryDetails(
            owner: String,
            repo: String,
            completionHandler: @escaping (RepositoryDetails) -> Void
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
                guard let downloadUrl = URL(string: dto.downloadUrl) else {
                    completionHandler(nil)
                    return
                }

                get(from: downloadUrl) { data in
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
                let currentCount = previousCount + dto.count

                if dto.count == itensPerPage {
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
    onComplete: @escaping (T) -> Void
) {
    get(from: URL(string: url)!) { data in
        guard let decodedData = decode(as: T.self, data: data) else {
            print("Got null decoded data when decoding type \(T.self)")
            return
        }

        onComplete(decodedData)
    }
}

private func get(from url: URL, onComplete: @escaping (Data) -> Void) {
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

        onComplete(data)
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
