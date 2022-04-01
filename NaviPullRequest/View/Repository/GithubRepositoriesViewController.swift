//
//  GithubRepositoriesViewController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

class GithubRepositoriesViewController: ActivityIndicatorViewController {
    
    let repositoryTable = UITableView.init()
    private let activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
    var repositories:[Repo]?
    weak var dataDelegate: PullRequestDataProtocol? {
        didSet {
           fetchRepositoriesToPopulate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        self.setLabelText(text: "The listed users and repositories cannot be searched either because the resources do not exist or you do not have permission to view them.")
    }
    
    func setUpTable() {
        self.view.addSubview(repositoryTable)
        repositoryTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([repositoryTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10), repositoryTable.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor), repositoryTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor), repositoryTable.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)])
        repositoryTable.dataSource = self
        repositoryTable.delegate = self
        repositoryTable.separatorInset = .zero
        let refresh = UIRefreshControl.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        refresh.addTarget(self, action: #selector(reloadPullRequests), for: .valueChanged)
        repositoryTable.refreshControl = refresh
    }
    
    func fetchRepositoriesToPopulate(reloadCompleted: (()->Void)? = nil) {
        dataDelegate?.getRepositories(completion: {
            repos in
            reloadCompleted?()
            if repos == nil {
                self.showAlert()
                return
            }
            self.repositories = repos!
            DispatchQueue.main.async {
                self.repositoryTable.reloadData()
            }
        })
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
        self.fetchRepositoriesToPopulate() {
            DispatchQueue.main.async {
                self.repositoryTable.refreshControl?.endRefreshing()
            }
        }
    }
   
}

extension GithubRepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if repositories == nil {
            showLoading()
            return 0
        } else {
            stopLoading()
        }
        let count = repositories!.count
        if count == 0 {
            self.showLabel()
        } else {
            self.hideLabel()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = repositories?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pullViewController = PullRequestViewController.init(repoName: repositories?[indexPath.row].name ?? "")
        tableView.deselectRow(at: indexPath, animated: true)
        pullViewController.delegate = self.dataDelegate
        (self.navigationController as? UserNavigationController)?.hideProfilePic()
        self.navigationController?.pushViewController(pullViewController, animated: true)
    }
}

