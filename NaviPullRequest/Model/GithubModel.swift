//
//  GithubModel.swift
//  NaviPullRequest
//
//  Created by Keerthika Priya on 31/03/22.
//

import Foundation
import UIKit

struct Repo:Decodable {
    var id:  Int
    var name: String
}

struct PullRequest: Decodable {
    var created_at: String?
    var closed_at:String?
    var title: String
}

class GithubModel {
    
    let userName: String
    var repositories: [Repo]?
    var pullRequests: [String:[PullRequest]]?
    var profilePic: UIImage?
    let requestQueue = DispatchQueue.init(label: "pullRequests", qos: .background, attributes: .concurrent)
    
    struct ProfileDetails:Decodable {
        var avatar_url: String
        var login: String
    }
    
    init(userName: String) {
        self.userName = userName
    }
    
    //MARK: Repository
    
    func getRepositories(completion: @escaping ([Repo]?) -> Void) {
        if let url = URL.init(string: "https://api.github.com/users/\(userName)/repos"){
            var request = URLRequest.init(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "application")
            URLSession.shared.dataTask(with: request, completionHandler: {
                data,response, error in
                if self.checkIfError(response: response, error: error) {
                    completion(nil)
                    return
                }
                if let data = data,let repos = try? JSONDecoder.init().decode([Repo].self, from: data) {
                    self.repositories = repos
                } else {
                    self.repositories = []
                }
                completion(self.repositories ?? [])
            }).resume()
        }
    }
    
    //MARK: Pull Request
    
    func getAllPullRequestDetails(completion: @escaping([PullRequest]?) -> Void) {
        if repositories == nil {
        getRepositories(completion: {
            repos in
            if repos == nil {
                return
            }
            self.showPull(repos: repos!, pullCompletion: completion)
         })
        } else {
            self.showPull(repos: repositories ?? [], pullCompletion: completion)
        }
    }
    
    func showPull(repos: [Repo], pullCompletion: @escaping([PullRequest]?)->()) {
        for i in repos {
            fetchPullRequestsFor(name: i.name, pullCompletion: {
                showError in
                if showError {
                    pullCompletion(nil)
                    return
                }
                if repos.count == (self.pullRequests?.count ?? 0) {
                    pullCompletion(self.getPullRequestsFromDictionary())
                }
            })
        }
    }
    
    func fetchPullRequestsFor(name: String, pullCompletion: @escaping(Bool)->()) {
        if var urlComponent = URLComponents.init(string: "https://api.github.com/repos/\(userName)/\(name)/pulls") {
            urlComponent.queryItems = [URLQueryItem.init(name: "state", value: "close")]
            guard let url = urlComponent.url else { return }
            var request = URLRequest.init(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "application")
            URLSession.shared.dataTask(with: request, completionHandler: {
                data,response,error in
            
                if self.checkIfError(response: response, error: error) {
                    pullCompletion(true)
                    return
                }
            
                if let data = data, let pull_request = try? JSONDecoder.init().decode([PullRequest].self, from: data) {
                    self.requestQueue.sync(flags: .barrier, execute: {
                        if self.pullRequests == nil {
                            self.pullRequests = [name : pull_request]
                        } else {
                            self.pullRequests?[name] = pull_request
                        }
                    })
                } else {
                    if self.pullRequests != nil {
                        self.pullRequests?[name] = []
                    } else {
                        self.pullRequests = [name: []]
                    }
                }
            pullCompletion(false)
        }).resume()
      }
    }
    
    func getPullRequestsFromDictionary() -> [PullRequest] {
        var pullrequest = [PullRequest]()
        for i in pullRequests ?? [:] {
            pullrequest.append(contentsOf: i.value)
        }
        return pullrequest
    }
    
    func getPullRequestDetails(forRepoName: String, completion: @escaping ([PullRequest]?) -> Void) {
        if let pullReq = pullRequests?[forRepoName] {
            completion(pullReq)
        } else {
            self.fetchPullRequestsFor(name: forRepoName, pullCompletion: {
                showerror in
                if showerror {
                    completion(nil)
                    return
                }
                completion(self.getPullRequestsFromDictionary())
            })
        }
    }
    
    //MARK: ProfilePic
    
    func getUserDetails(completion: @escaping(String, UIImage?) -> Void) {
        if let url = URL.init(string: "https://api.github.com/users/\(userName)"){
            var request = URLRequest.init(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "application")
            URLSession.shared.dataTask(with: request, completionHandler: {
                data,response, error in
                if let data = data,let profileDetails = try? JSONDecoder.init().decode(ProfileDetails.self, from: data) {
                    self.getUserProfilePic(userName: profileDetails.login,url: profileDetails.avatar_url, completion: completion)
                }
                
            }).resume()
        }
    }
    
    func getUserProfilePic(userName: String,url:String,completion: @escaping(String,UIImage?) -> Void) {
        if let url = URL.init(string: url){
            var request = URLRequest.init(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "application")
            URLSession.shared.dataTask(with: request, completionHandler: {
                data, response, error in
                if let data = data,let profileImage = UIImage.init(data: data) {
                    self.profilePic = profileImage
                    completion(userName, profileImage)
                }
                
            }).resume()
        }
    }
  
    func checkIfError(response: URLResponse?, error: Error?) -> Bool {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        if (error != nil ||  (statusCode < 200 || statusCode > 299)) {
            return true
        }
        return false
    }
}
