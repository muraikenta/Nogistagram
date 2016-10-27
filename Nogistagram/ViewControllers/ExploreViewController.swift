//
//  ExploreViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class ExploreViewController: UIViewController {
    
    var posts: [Post] = []
    var postCollectionView = PostCollectionView()

    @IBOutlet weak var postCollectionWrapper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postCollectionView = PostCollectionView.instantiate()
        self.postCollectionView.frame = self.postCollectionWrapper.bounds
        self.postCollectionWrapper.addSubview(self.postCollectionView)
        
        self.loadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPosts() {
        if let authDict = SessionHelper.authDict() {
            // TODO: おすすめの投稿を取り出す
            Alamofire
                .request("\(Constant.Api.root)/posts/timeline", method: .get, headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJsons = JSON(value)
                        for (_, postJson) in postJsons {
                            let post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                            post.save()
                        }
                        self.postCollectionView.posts = Post.all()
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
    
}
