//
//  LoginPage.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class LoginPage: UIViewController {
    
    let userNameField = UITextField()
    let skip = UIButton.init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.sharedColor.backgroundColor
        setUpLoginField()
        setGithubImage()
    }
    func setGithubImage() {
        let githubImage = UIImageView.init(image: UIImage.init(named: "GitHub"))
        self.view.addSubview(githubImage)
        githubImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([githubImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),githubImage.bottomAnchor.constraint(equalTo: self.userNameField.topAnchor, constant: -5), githubImage.widthAnchor.constraint(equalToConstant: 40), githubImage.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    func setUpLoginField() {
        self.view.addSubview(userNameField)
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([userNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),userNameField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), userNameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5), userNameField.heightAnchor.constraint(equalToConstant: 40)])
        userNameField.placeholder = "Enter your username..."
        userNameField.sizeToFit()
        userNameField.borderStyle = .roundedRect
        userNameField.addTarget(self, action: #selector(changeSkipToShow), for: .allEditingEvents)
        
        self.view.addSubview(skip)
        skip.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([skip.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 10), skip.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.5), skip.heightAnchor.constraint(equalToConstant: 30), skip.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)])
        skip.sizeToFit()
        skip.setTitle("Skip", for: .normal)
        skip.setTitleColor(.black, for: .normal)
        skip.addTarget(self, action: #selector(clickedSkip), for: .touchUpInside)
    }
    
    @objc func clickedSkip() {
        var userName: String = "InvigHere"
        if userNameField.text != nil && userNameField.text != "" {
            userName = userNameField.text!
        }
        let tabController = TabBarViewController.init(userName: userName)
        let navVC = UserNavigationController.init(rootViewController: tabController)
        navVC.dataDelegate = tabController.pullRequestController
        navVC.modalPresentationStyle = .overFullScreen
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func changeSkipToShow() {
        if userNameField.text != "" && userNameField.text != nil {
            skip.setTitle("Show", for: .normal)
        } else {
            skip.setTitle("Skip", for: .normal)
        }
    }
}
