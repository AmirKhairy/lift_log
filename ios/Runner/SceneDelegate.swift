import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        let splashViewController = SplashViewController()

        window.rootViewController = splashViewController
        self.window = window

        window.makeKeyAndVisible()
    }
}