//
//  SearchResultTableViewCell.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultTableViewCell: UITableViewCell {
    
    var user: User = User() {
        didSet {
            render()
        }
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var uniqueNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render() {
        userImageView.kf.setImage(with: URL(string: user.imageUrl), placeholder: UIImage(named: "setting"), options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
            self.setNeedsLayout()
            self.layoutIfNeeded()
        })
        uniqueNameLabel.text = user.uniqueName
        userNameLabel.text = user.name
    }
}
