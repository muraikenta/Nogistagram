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
        let user: User = self.post.user!
        userNameLabel.text = user.uniqueName
        postImageView.kf.setImage(with: URL(string: self.post.imageUrl))
        postBodyTextView.text = self.post.body
        userImageView.setCircleWebImage(str: user.imageUrl)
        let likeButtonImageName = post.isLiked ? "filledHeart" : "emptyHeart"
        likeButton.setImage(UIImage(named: likeButtonImageName), for: .normal)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let method: HTTPMethod = post.isLiked ? .delete : .post
        if let authDict = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/likes", method: method, parameters: ["post_id" : post.id], headers: authDict)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let postJson = JSON(value)
                        self.post = Mapper<Post>().map(JSON: postJson.object as! [String : Any])!
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
