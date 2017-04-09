//
//  PostTableViewCell.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/18.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import ObjectMapper

class PostTableViewCell: UITableViewCell {
    
    var tableController: HomeTableViewController!
    var index: Int!
    
    var post: Post = Post() {
        didSet {
            render()
        }
    }
    
    // MARK: Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postBodyTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        for userView: UIView in [self.userNameLabel, self.userImageView] {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.handleUserTap(_:)))
            tapRecognizer.delegate = self
            userView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleUserTap(_ gestureRecognizer: UIGestureRecognizer) {
        let userViewController = UserViewController.instantiate(storyboard: "Main")
        userViewController.user = self.post.user!
        self.tableController.navigationController?.pushViewController(userViewController, animated: true)
    }
    
    func deletePost(_ any: Any) {
        self.tableController.posts.remove(at: self.index)
        self.tableController.tableView.reloadData()
        
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/posts/\(self.post.id)", method: .delete, headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        self.post.delete()
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
    
    func render() {
        if let user = self.post.user {
            userNameLabel.text = user.uniqueName
            userImageView.setCircleWebImage(str: user.imageUrl)
        }
        postImageView.kf.setImage(with: URL(string: self.post.imageUrl))
        postBodyTextView.text = self.post.body
        let likeButtonImageName = post.isLiked ? "filledHeart" : "emptyHeart"
        likeButton.setImage(UIImage(named: likeButtonImageName), for: .normal)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if self.post.user!.id == SessionHelper.currentUser()!.id {
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: self.deletePost))
        }
        self.tableController.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let method: HTTPMethod = self.post.isLiked ? .delete : .post
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/likes", method: method, parameters: ["post_id" : post.id], headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJson = JSON(value)
                        self.post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                        self.post.save()
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
}
