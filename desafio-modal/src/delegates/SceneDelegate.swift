import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()

        window.frame = UIScreen.main.bounds
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        let gitService = GitService()
        let filterService = FilterService()

        appCoordinator = AppCoordinator(navigationController: navigationController, window: window,
                                        gitService: gitService,
                                        filterService: filterService)
        appCoordinator.start()
    }
}
