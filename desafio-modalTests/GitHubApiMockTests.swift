@testable import desafio_modal

import XCTest

class GitHubApiMockTests: XCTestCase {
    override func setUp() {
        GitHubApi.useMockedResponses = true
    }

    func testGetRepositories() throws {
        // arrange
        var repositories = Repositories()
        let sem = DispatchSemaphore(value: 0)

        // act
        GitHubApi.Get.repositories { repoList in
            defer { sem.signal() }
            XCTAssertNotNil(repoList)

            repositories = repoList!
        }
        sem.wait()

        // assert
        XCTAssertEqual("mojombo/grit", repositories.first!.fullName)
    }

    func testGetRepositoryDetails() throws {
        // arrange
        var details: RepositoryDetails!
        let sem = DispatchSemaphore(value: 0)

        let expectedDate: Date = {
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: "2008-01-12T05:50:53Z")
            XCTAssertNotNil(date)

            return date!
        }()

        // act
        GitHubApi.Get.repositoryDetails(fullName: "") { repo in
            defer { sem.signal() }
            XCTAssertNotNil(repo)

            details = repo
        }
        sem.wait()

        // assert
        XCTAssertEqual(expectedDate, details.createdAt)
        XCTAssertEqual(26, details.id)
    }

    func testGetReadme() throws {
        // arrange
        var readmeContents = ""
        let sem = DispatchSemaphore(value: 0)

        // act
        GitHubApi.Get.readme(fullName: "no-need-for-mocks") { readme in
            defer { sem.signal() }
            XCTAssertNotNil(readme)

            readmeContents = readme!
        }
        sem.wait()

        // assert
        XCTAssertEqual(
            "# surround.vim",
            readmeContents.split(separator: "\n").first!
        )
    }

    func testGetBranchCount() throws {
        // arrange
        var branchCount = -1
        let sem = DispatchSemaphore(value: 0)

        // act
        GitHubApi.Get.countBranches(fullName: "no-need-for-mocks") { count in
            defer { sem.signal() }
            XCTAssertNotNil(count)

            branchCount = count!
        }
        sem.wait()

        // assert
        XCTAssertEqual(8, branchCount)
    }

    func testGetCommitCount() throws {
        // arrange
        var commitCount = -1
        let sem = DispatchSemaphore(value: 0)

        // act
        GitHubApi.Get.countCommits(fullName: "no-need-for-mocks") { count in
            defer { sem.signal() }
            XCTAssertNotNil(count)

            commitCount = count!
        }
        sem.wait()

        // assert
        XCTAssertEqual(74890, commitCount)
    }
}
