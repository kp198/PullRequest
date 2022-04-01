//
//  ActivityIndicatorViewController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
    private let emptyLabel = UILabel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmptyBackground()
        addLoading()
    }
    func setUpEmptyBackground() {
        
        self.view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), emptyLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5), emptyLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7)])
        emptyLabel.isHidden = true
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
//        emptyLabel.text = "The listed users and repositories cannot be searched either because the resources do not exist or you do not have permission to view them."
        emptyLabel.isHidden = true
    }
    
    func addLoading() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), activityIndicator.heightAnchor.constraint(equalToConstant: 30), activityIndicator.widthAnchor.constraint(equalToConstant: 30)])
    }
    
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showLoading() {
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func setLabelText(text: String) {
        self.emptyLabel.text = text
    }
    
    func showLabel() {
        self.emptyLabel.isHidden = false
        self.view.bringSubviewToFront(emptyLabel)
    }
    
    func hideLabel() {
        self.emptyLabel.isHidden = true
    }
}
