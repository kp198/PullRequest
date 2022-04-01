//
//  GithubPullRequestViewController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import Foundation
import UIKit

class PullRequestViewController: ActivityIndicatorViewController {
    
    let requestTable = UITableView.init()
    var pullRequestDetails:[PullRequest]? {
        didSet {
            DispatchQueue.main.async {
                self.requestTable.reloadData()
            }
        }
    }
    var repoName: String?
    weak var delegate: PullRequestDataProtocol? {
        didSet {
           fetchRequestsToPopulate()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(repoName: String?) {
        self.repoName = repoName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iOS15Fixes()
        setUpTable()
        self.setLabelText(text: "Hey! It's empty here.")
    }
    
    func setUpTable() {
        self.view.addSubview(requestTable)
        requestTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([requestTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10), requestTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor), requestTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor), requestTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)])
        requestTable.dataSource = self
        requestTable.delegate = self
        requestTable.separatorInset = .zero
        let refresh = UIRefreshControl.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        refresh.addTarget(self, action: #selector(reloadPullRequests), for: .valueChanged)
        requestTable.refreshControl = refresh
    }
    
    @available(iOS 15.0,*)
    func iOS15Fixes() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = Color.sharedColor.backgroundColor
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    func fetchRequestsToPopulate(reloadCompleted: (()->Void)? = nil) {
        if repoName == nil {
            delegate?.getAllPullRequestDetails(completion: {
                [weak self] pullDetails in
                reloadCompleted?()
                if pullDetails == nil {
                    self?.showAlert()
                    return
                }
                self?.pullRequestDetails = pullDetails!
            })
        } else {
            delegate?.getPullRequestDetails(forRepoName: repoName!,completion: {
               [weak self] pullDetails in
                reloadCompleted?()
                if pullDetails == nil {
                    self?.showAlert()
                    return
                }
                self?.pullRequestDetails = pullDetails!
            })
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
        let alert = UIAlertController.init(title: "Sorry! Something went wrong", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: {_ in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
    @objc func reloadPullRequests() {
        self.fetchRequestsToPopulate() {
            [weak self] in
            DispatchQueue.main.async {
                self?.requestTable.refreshControl?.endRefreshing()
            }
        }
    }
    
}

extension PullRequestViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pullRequestDetails == nil {
            showLoading()
            return 0
        } else {
            stopLoading()
        }
        
        let count = pullRequestDetails!.count
        if count == 0 {
            self.showLabel()
            return count
        } else {
            self.hideLabel()
        }
        return count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PullRequestTableViewCell.init()
        if indexPath.row == 0 {
            cell.titleLabel.text = "Request Name"
            cell.setCreatedTime(time: "Created Time", fontSize: 14)
            cell.setClosedTime(time: "Closed Time", fontSize: 14)
            return cell
        }
        cell.titleLabel.text = pullRequestDetails?[indexPath.row-1].title
        cell.setCreatedTime(time:  pullRequestDetails?[indexPath.row-1].created_at)
        cell.setClosedTime(time:  pullRequestDetails?[indexPath.row-1].closed_at)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
