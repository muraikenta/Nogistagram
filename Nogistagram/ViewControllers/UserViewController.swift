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
        self.renderUserData()
        
        self.postCollectionView = PostCollectionView.instantiate()
        self.postCollectionView.frame = self.postCollectionWrapper.bounds
        self.postCollectionWrapper.addSubview(self.postCollectionView)
        
        self.loadPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userImageView.setCircleWebImage(str: user.imageUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderUserData() {
        self.title = user.uniqueName
        self.userNameLabel.text = self.user.name
        self.userIntroductionLabel.text = self.user.introduction
        self.userWebsiteLabel.text = self.user.website
    }
    

    func loadPosts() {
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/posts", method: .get, parameters: ["user_id": self.user.id], headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJsons = JSON(value)
                        for (_, postJson) in postJsons {
                            let post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                            post.save()
                            if self.user.posts.filter(NSPredicate(format: "id = \(post.id)")).isEmpty {
                                self.user.write(block: { _ in self.user.posts.append(post) })
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
