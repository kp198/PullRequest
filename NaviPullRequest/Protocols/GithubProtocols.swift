//
//  GithubProtocols.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import UIKit

protocol PullRequestDataProtocol: NSObjectProtocol {
    func getRepositories(completion: @escaping([Repo]?)->Void)
    func getAllPullRequestDetails(completion: @escaping([PullRequest]?)->Void)
    func getPullRequestDetails(forRepoName: String, completion: @escaping([PullRequest]?)->Void)
}

protocol ProfileDetailsProtocol: NSObjectProtocol {
    func getUserDetails(completion:@escaping(String,UIImage?)->Void)
}
