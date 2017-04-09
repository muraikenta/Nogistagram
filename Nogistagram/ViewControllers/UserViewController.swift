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

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIntroductionLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var postCollectionWrapper: UIView!
    
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
                    self.followersCount.text = String(user.followersCount)
                    self.followingsCount.text = String(user.followingsCount)
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

}
