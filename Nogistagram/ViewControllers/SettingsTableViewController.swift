//
//  SettingsTableViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/10.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import KeychainAccess
import FacebookCore

class SettingsTableViewController: UITableViewController {
    
    struct Section {
        let title: String
        let cells: [Cell]
    }
    
    struct Cell {
        let title: String
        let action: () -> Void
    }
    
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // selfを用いたいので、viewDidLoad内で中身を代入
        sections = [
            Section(
                title: "アカウント",
                cells: [
                    Cell(title: "プロフィールを編集", action: {}),
                    Cell(title: "パスワードを変更", action: {}),
                    Cell(title: "「いいね！」した投稿", action: {}),
                ]
            ),
            Section(
                title: " ",
                cells: [
                    Cell(title: "検索履歴を削除", action: {}),
                    Cell(title: "ログアウト", action: self.logout),
                ]
            )
        ]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func logout() {
        let keychain = Keychain(service: Constant.Keychain.service)
        do {
            try keychain.remove("uid")
            try keychain.remove("accessToken")
            try keychain.remove("clientId")
            
            AccessToken.current = nil
            
            Session.all().delete()
            
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginViewController, animated: true, completion: nil)
        } catch let error {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.row].action()
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
