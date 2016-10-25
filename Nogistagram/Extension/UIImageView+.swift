//
//  File.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/24.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Kingfisher

public extension UIImageView {
    
    func setWebImage(url: URL?) {
        if let url = url {
            kf.setImage(with: url)
        }
    }
    
    func setWebImage(str: String) {
        setWebImage(url: URL(string: str))
    }
    
    func setCircleWebImage(url: URL?) {
        if let url = url {
            // TODO: placeholder変える
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
            setWebImage(url: url)
        }
    }
    
    func setCircleWebImage(str: String) {
        setCircleWebImage(url: URL(string: str))
    }
}
