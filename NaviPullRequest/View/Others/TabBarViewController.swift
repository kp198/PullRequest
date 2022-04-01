//
//  TabBarViewController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    let repositoryVC: GithubRepositoriesViewController
    let pullRequestController: PullRequestController
    init(userName: String) {
        repositoryVC = GithubRepositoriesViewController.init()
        pullRequestController = PullRequestController.init(username: userName)
        super.init(nibName: nil, bundle: nil)
        repositoryVC.dataDelegate = pullRequestController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Color.sharedColor.tabBarColor
        setUpTabViewControllers()
        setUpTabBarItems()
    }

    func setUpTabViewControllers() {
        self.viewControllers = [repositoryVC,pullRequestController.pullView]
    }
   
    func setUpTabBarItems() {
        let titles = ["Repositories","Pull Requests"]
        let images = ["externaldrive", "arrow.triangle.pull"]
        for i in 0..<(viewControllers?.count ?? 0) {
            let item = UITabBarItem.init(title: titles[i], image: UIImage.init(systemName: images[i]), tag: i)
            item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
            viewControllers?[i].tabBarItem = item
        }
    }
}

