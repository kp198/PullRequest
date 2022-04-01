//
//  PullRequestController.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import Foundation
import UIKit

class PullRequestController: NSObject, PullRequestDataProtocol, ProfileDetailsProtocol {
    
  
    let pullView = PullRequestViewController.init()
    let pullModel: GithubModel
    init(username: String) {
        pullModel = GithubModel.init(userName: username)
        super.init()
        pullView.delegate = self
    }
    
    func getAllPullRequestDetails(completion: @escaping([PullRequest]?) -> Void) {
        pullModel.getAllPullRequestDetails(completion: completion)
    }
    
    func getPullRequestDetails(forRepoName: String, completion: @escaping ([PullRequest]?) -> Void) {
        pullModel.getPullRequestDetails(forRepoName: forRepoName, completion: completion)
    }
    
    func getRepositories(completion: @escaping ([Repo]?) -> Void) {
        pullModel.getRepositories(completion: completion)
    }
    
    func getUserDetails(completion: @escaping(String, UIImage?) -> Void) {
        pullModel.getUserDetails(completion: completion)
    }
    
}
