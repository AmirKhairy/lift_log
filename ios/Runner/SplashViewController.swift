import UIKit
import Lottie

class SplashViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottieAnimation()
    }

    private func setupLottieAnimation() {
        animationView = LottieAnimationView(name: "splash_logo")

        animationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView?.center = view.center
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce

        view.addSubview(animationView!)

        animationView?.play { [weak self] _ in
            self?.navigateToFlutter()
        }
    }

    private func navigateToFlutter() {
        let flutterViewController = FlutterViewController()
        flutterViewController.modalPresentationStyle = .fullScreen
        self.present(flutterViewController, animated: true, completion: nil)
    }
}