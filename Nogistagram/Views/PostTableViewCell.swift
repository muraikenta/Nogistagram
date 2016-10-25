//
//  PostTableViewCell.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/18.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Kingfisher

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
        self.userNameLabel.text = user.uniqueName
        self.postImageView.kf.setImage(with: URL(string: post.imageUrl))
        self.postBodyTextView.text = post.body
        self.userImageView.kf.setImage(with: URL(string: user.imageUrl), placeholder: UIImage(named: "setting"), options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            print(self.userImageView.frame.height / 2)
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
            print(self.userImageView.layer.cornerRadius)
        })
    }

}
