//
//  ExploreViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    var posts: [Post] = []

    @IBOutlet weak var postCollectionWrapper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let postCollectionView = PostCollectionView.instantiate()
        postCollectionView.frame = postCollectionWrapper.bounds
        postCollectionWrapper.addSubview(postCollectionView) 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
