//
//  UserViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/23.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class UserViewController: UIViewController {
    
    var user: User!
    var postCollectionView = PostCollectionView()
    var isFollwing: Bool = false {
        didSet {
            if isFollwing {
                followButton.setTitle("フォロー中", for: .normal)
                followButton.backgroundColor = .white
                followButton.setTitleColor(.black, for: .normal)
                followButton.layer.borderColor = UIColor.black.cgColor
                followButton.layer.borderWidth = 1
            } else {
                followButton.setTitle("フォローする", for: .normal)
                followButton.backgroundColor = #colorLiteral(red: 0.347109437, green: 0.5949048996, blue: 1, alpha: 1)
                followButton.setTitleColor(.white, for: .normal)
            }
        }
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIntroductionLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var postCollectionWrapper: UIView!
    @IBOutlet weak var followButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        
        self.user = self.user ?? SessionHelper.currentUser()!
        self.user.save()
        self.renderBasicUserData()
        
        self.postCollectionView = PostCollectionView.instantiate()
        self.postCollectionView.frame = self.postCollectionWrapper.bounds
        self.postCollectionWrapper.addSubview(self.postCollectionView)
        
        self.loadDetailedUserData()
        self.loadFollow()
        self.loadPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userImageView.setCircleWebImage(str: user.imageUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderBasicUserData() {
        self.title = user.uniqueName
        self.userNameLabel.text = self.user.name
        self.userIntroductionLabel.text = self.user.introduction
        self.userWebsiteLabel.text = self.user.website
    }
    
    func loadDetailedUserData() {
        guard let authDict = SessionHelper.authDict() else {
            return   
        }
        
        Alamofire
            .request("\(Constant.Api.root)/users/\(self.user.id)", method: .get, headers: authDict)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let userDict = JSON(value).dictionaryObject!
                    guard let user = User.find(userDict["id"] as! Int) else {
                        return
                    }
                    user.write {_ in
                        user.postsCount = userDict["posts_count"] as! Int
                        user.followersCount = userDict["followers_count"] as! Int
                        user.followingsCount = userDict["followings_count"] as! Int
                    }
                    self.postsCountLabel.text = String(user.postsCount)
                    self.followersCountLabel.text = String(user.followersCount)
                    self.followingsCountLabel.text = String(user.followingsCount)
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
    

    func loadPosts() {
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/users/\(self.user.id)/posts", method: .get, headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJsons = JSON(value)
                        for (_, postJson) in postJsons {
                            let post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                            post.save()
                            if self.user.posts.filter(NSPredicate(format: "id = \(post.id)")).isEmpty {
                                self.user.write { _ in self.user.posts.append(post) }
                            }
                        }
                        self.postCollectionView.posts = Array(self.user.posts)
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
    
    func loadFollow() {
        guard let authDict = SessionHelper.authDict() else {
            return
        }
        
        let currentUser = SessionHelper.currentUser()!
        let parameters: [String: Int] = [
            "from_user_id": currentUser.id,
            "to_user_id": self.user.id,
        ]
        
        Alamofire
            .request("\(Constant.Api.root)/follows/find", method: .get, parameters: parameters,headers: authDict)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let follow = JSON(value)["follow"]
                    self.isFollwing = follow != nil
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
    
    @IBAction func onFollowButtonTapped(_ sender: UIButton) {
        guard let authDict = SessionHelper.authDict() else {
            return   
        }
        
        let method: HTTPMethod = self.isFollwing ? .delete : .post
        
        let fromUserId = SessionHelper.currentUser()!.id
        let toUserId = self.user.id
        let parameters: [String: Int] = [
            "from_user_id": fromUserId,
            "to_user_id": toUserId,
        ]
        
        Alamofire
            .request("\(Constant.Api.root)/follows", method: method, parameters: parameters, headers: authDict)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let followJson = JSON(value)["follow"].dictionaryObject!
                    self.isFollwing = !self.isFollwing
                    if self.isFollwing {
                        let follow = Mapper<Follow>().map(JSON: followJson)
                        follow?.save()
                    } else {
                        let follow = Follow.find(followJson["id"] as! Int)
                        follow?.delete()
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }

}
