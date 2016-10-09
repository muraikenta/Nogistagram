//
//  SettingsTableViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/10.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Dollar

class SettingsTableViewController: UITableViewController {
    
    let sectionComponents: [(title: String, cells: [(title: String, action: () -> Void)])] = [
        (
            title: "アカウント",
            cells: [
                (title: "プロフィールを編集", action: {}),
                (title: "パスワードを変更", action: {}),
                (title: "「いいね！」した投稿", action: {}),
            ]
        ),
        (
            title: " ",
            cells: [
                (title: "検索履歴を削除", action: {}),
                (title: "ログアウト", action: {}),
            ]
        ),
    ]

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
        return sectionComponents.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionComponents[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionComponents[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = sectionComponents[indexPath.section].cells[indexPath.row].title
        return cell
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
