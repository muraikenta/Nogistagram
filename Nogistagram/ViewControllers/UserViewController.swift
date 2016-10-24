//
//  UserViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/23.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Kingfisher

class UserViewController: UIViewController {
    
    var user: User!

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIntroductionLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        
        user = user ?? SessionHelper.currentUser()!
        user.save()
        render()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        self.title = user.uniqueName
        userImageView.kf.setImage(with: URL(string: user.imageUrl))
        userNameLabel.text = user.name
        userIntroductionLabel.text = user.introduction
        userWebsiteLabel.text = user.website
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
