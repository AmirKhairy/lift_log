import UIKit
import Lottie
import Flutter

class SplashViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupLottieAnimation()
    }

    private func setupLottieAnimation() {

        let animation = LottieAnimation.named("splash_logo")

        animationView = LottieAnimationView(animation: animation)

        guard let animationView = animationView else {
            print("❌ Failed to load splash_logo.json")
            navigateToFlutter()
            return
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            animationView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            animationView.widthAnchor.constraint(
                equalToConstant: 300
            ),

            animationView.heightAnchor.constraint(
                equalToConstant: 300
            )
        ])

        animationView.play { [weak self] finished in
            guard finished else {
                return
            }

            self?.navigateToFlutter()
        }
    }

    private func navigateToFlutter() {

        let flutterViewController = FlutterViewController()

        flutterViewController.modalPresentationStyle = .fullScreen

        present(
            flutterViewController,
            animated: false
        )
    }
}