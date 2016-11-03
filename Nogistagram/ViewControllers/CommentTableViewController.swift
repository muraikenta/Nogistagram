//
//  CommentTableViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/30.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class CommentTableViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var commentField: UITextField!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func comment(_ sender: UIBarButtonItem) {
        if let body: String = self.commentField.text {
            let params: [String : Any] = ["post_id" : self.post.id, "body" : body]
            if let authDict = SessionHelper.authDict() {
                Alamofire
                    .request("\(Constant.Api.root)/comments", method: .post, parameters: params, headers: authDict)
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let postJson = JSON(value)
                            //self.post = Mapper<Post>().map(JSON: postJson.object as! [String : Any])!
                            //self.post.save()
                            print(postJson)
                        case .failure(let error):
                            print(error)
                        }
                    }
            } else {
                print("Error: authToken is nil")
            }
        } else {
            // TODO: viewModelでvalidation？
            print("body does not exist")
        }
    }
}
