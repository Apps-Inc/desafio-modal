import Foundation

struct GitHubSearchResults {
    let totalCount: Int
    let pageNum: Int
    let items: [RepositoryDetails]

    init(_ dto: GitHubSearchResposeDto, page: Int) {
        let convertedItems = dto.items.compactMap(RepositoryDetails.init)

        totalCount = dto.totalCount
        pageNum = page
        items = convertedItems
    }
}
