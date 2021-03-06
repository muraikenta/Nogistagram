//
//  HomeTableViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/16.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class HomeTableViewController: UITableViewController {
    
    var posts: [Post] = []

    override func viewDidLoad() {
        posts = Post.all()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo_black.png")
        navigationItem.titleView = imageView
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // MEMO: これはviewDidApperとかに移してRealmから持ってくるように
        self.loadPosts()
    }
    
    func loadPosts() {
        if let authToken = SessionHelper.authDict() {
            Alamofire
                .request("\(Constant.Api.root)/posts/timeline", method: .get, headers: authToken)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        Post.deleteAll()
                        User.deleteAll()
                        let postJsons = JSON(value)
                        for (_, postJson) in postJsons {
                            let user =
                                User.find(postJson["user"].dictionaryObject!["id"] as! Int)
                                ?? Mapper<User>().map(JSON: postJson["user"].dictionaryObject!)!
                            user.save()
                            let post = Mapper<Post>().map(JSON: postJson.dictionaryObject!)!
                            post.save()
                            user.write { _ in user.posts.append(post) }
                        }
                        self.posts = Post.all()
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                    
            }
        } else {
            print("Error: authToken is nil")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.index = indexPath.row
        cell.post = posts[indexPath.row]
        cell.tableController = self
        return cell
    }

}
