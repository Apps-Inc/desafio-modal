import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        GitHubApi.Get.repositories { res in
            print("compiler flag: \(res[0 ... 3])")
        }
    }
}
