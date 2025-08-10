import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home_icon"), tag: 0)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let shortsVC = UINavigationController(rootViewController: ShortsViewController())
        shortsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "shorts_icon"), tag: 1)
        shortsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let uploadVC = UINavigationController(rootViewController: UploadViewController())
        uploadVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "upload_icon"), tag: 2)
        uploadVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let subsVC = UINavigationController(rootViewController: SubscriptionsViewController())
        subsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "subscriptions_icon"), tag: 3)
        subsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let libraryVC = UINavigationController(rootViewController: LibraryViewController())
        libraryVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "library_icon"), tag: 4)
        libraryVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        viewControllers = [homeVC, shortsVC, uploadVC, subsVC, libraryVC]
    }
}
