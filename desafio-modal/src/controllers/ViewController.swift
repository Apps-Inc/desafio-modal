import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        GitHubApi.Get.repositories { res in
            print("repositories: \(res[0 ... 3])")
        }

        GitHubApi.Get.repositoryDetails(owner: "Apps-Inc", repo: "desafio-modal") { res in
            print("details: \(res)")
        }
    }
}
