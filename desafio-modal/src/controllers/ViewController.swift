import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        // GitHubApi.useMockedResponses = true
        GitHubApi.Get.repositories { res in
            print("repositories: \(res[0 ... 3])")
        }

        GitHubApi.Get.repositoryDetails(owner: "Apps-Inc", repo: "desafio-modal") { res in
            print("details: \(res)")
        }

        GitHubApi.Get.readme(fullName: "Apps-Inc/criptoview") { contents in
            print("readme: \(contents ?? "nil")")
        }
    }
}
