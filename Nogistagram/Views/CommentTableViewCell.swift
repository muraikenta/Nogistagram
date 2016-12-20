//
//  CommentTableViewCell.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/11/03.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var comment: Comment = Comment() {
        didSet {
            render()
        }
    }
    
    // MARK: Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render() {
        let user: User = comment.user!
        userNameLabel.text = user.uniqueName
        commentBodyLabel.text = comment.body
        userImageView.setCircleWebImage(str: user.imageUrl)
    }

}
