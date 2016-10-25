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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render() {
        let user: User = post.user!
        userNameLabel.text = user.uniqueName
        postImageView.kf.setImage(with: URL(string: post.imageUrl))
        postBodyTextView.text = post.body
        userImageView.kf.setImage(with: URL(string: user.imageUrl), placeholder: UIImage(named: "setting"), options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
        })
        let likeButtonImageName = post.isLiked ? "filledHeart" : "emptyHeart"
        likeButton.setImage(UIImage(named: likeButtonImageName), for: UIControlState.normal)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // let method = post.isLiked ? ".delete" : ".post"
        if let authToken = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/likes", method: post.isLiked ? .delete : .post, parameters: ["post_id" : post.id], headers: authToken)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJson = JSON(value)
                        let post = Mapper<Post>().map(JSON: postJson.object as! [String : Any])!
                        post.save()
                        self.post = post
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }
}
