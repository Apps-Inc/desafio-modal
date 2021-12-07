import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        // GitHubApi.useMockedResponses = true
        GitHubApi.Get.repositories { res in
            print("repositories: \(res[0 ... 3])")
        }

        GitHubApi.Get.repositories(lastId: 92348) { res in
            print("repositories since 92348: \(res[0 ... 3])")
        }

        GitHubApi.Get.repositoryDetails(owner: "Apps-Inc", repo: "desafio-modal") { res in
            print("details: \(res)")
        }

        GitHubApi.Get.readme(fullName: "Apps-Inc/criptoview") { contents in
            print("readme: \(contents ?? "nil")")
        }

        GitHubApi.Get.countBranches(fullName: "Apps-Inc/flygondex") { count in
            print("branch count: \(count ?? -1)")
        }
    }
}
