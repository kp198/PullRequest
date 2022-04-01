//
//  UserNavigationController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class UserNavigationController: UINavigationController {
    
    let userProfilePic = UIImageView.init(image: UIImage.init(systemName: "person.crop.circle"))
    let nameLabel = UILabel.init()
    
    weak var dataDelegate: ProfileDetailsProtocol? {
        didSet {
            self.dataDelegate?.getUserDetails(completion: {
                name , userPic in
                DispatchQueue.main.async {
                    self.nameLabel.text = name + "'s Git"
                    self.userProfilePic.image = userPic
                }
            })
        }
    }
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        self.navigationBar.backgroundColor = Color.sharedColor.backgroundColor
        setUpProfilePic()
        setUpNameLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpProfilePic() {
        self.navigationBar.addSubview(userProfilePic)
        userProfilePic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ userProfilePic.widthAnchor.constraint(equalToConstant: 40),userProfilePic.heightAnchor.constraint(equalToConstant: 40), userProfilePic.leadingAnchor.constraint(equalTo:self.navigationBar.leadingAnchor, constant: 5), userProfilePic.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)])
        userProfilePic.layer.cornerRadius = 20
        userProfilePic.layer.borderColor = Color.sharedColor.borderColor.cgColor
        userProfilePic.clipsToBounds = true
    }
    
    func setUpNameLabel() {
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([nameLabel.centerYAnchor.constraint(equalTo: self.navigationBar.centerYAnchor), nameLabel.centerXAnchor.constraint(equalTo: self.navigationBar.centerXAnchor), nameLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6)])
        nameLabel.textAlignment = .center
    }
    
    func hideProfilePic() {
        userProfilePic.isHidden = true
    }
    
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        self.userProfilePic.isHidden = true
//        super.pushViewController(viewController, animated: animated)
//    }
//
    override func popViewController(animated: Bool) -> UIViewController? {
        self.userProfilePic.isHidden = false
        return super.popViewController(animated: animated)
    }
}
