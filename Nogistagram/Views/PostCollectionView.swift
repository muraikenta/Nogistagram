//
//  PostCollectionView.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/27.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class PostCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var posts: [Post] = []
    let cellIdentifier = "PostCollectionCell"
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.loadPosts()
    }
    
    func loadPosts() {
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/posts", method: .get, headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJsons = JSON(value)
                        for (_, postJson) in postJsons {
                            let post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                            post.save()
                        }
                        self.posts = Post.all()
                        self.collectionView.reloadData()
                        self.collectionView.adaptBeautifulGrid(numberOfGridsPerRow: 3, gridLineSpace: 2.0)
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PostCollectionViewCell
        let post = posts[indexPath.row]
        cell.postImageView.kf.setImage(with: URL(string: post.imageUrl))
        return cell
    }
    
}
