//
//  SearchViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import PagingMenuController
import ObjectMapper
import SwiftyJSON
import Alamofire
import RealmSwift

var userResultsController = SeachResultTableViewController(style: .plain)
var tagResultsController = SeachResultTableViewController(style: .plain)
var spotResultsController = SeachResultTableViewController(style: .plain)

private var pagingControllers: [UIViewController] {
    return [userResultsController, tagResultsController, spotResultsController]
}

struct MenuOptions: MenuViewCustomizable {
    var itemsOptions: [MenuItemViewCustomizable] {
        return [MenuItem(title: "ピープル"), MenuItem(title: "タグ"), MenuItem(title: "スポット")]
    }
    
    var displayMode: MenuDisplayMode {
        return .segmentedControl
    }
    
    var focusMode: MenuFocusMode {
        return .underline(height: 1, color: UIColor.darkGray, horizontalPadding: 0, verticalPadding: 0)
    }
    
    var animationDuration: TimeInterval {
        return 0.2
    }
    
    struct MenuItem: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode
        
        init(title: String) {
            displayMode = .text(title: MenuItemText(text: title))
        }
    }
}

struct PagingMenuOptions: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
}

class SearchViewController: UIViewController {
    var options: PagingMenuControllerCustomizable! = PagingMenuOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.setup(options)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(_ text: String) {
        Alamofire
            .request("\(Constant.Api.root)/seach", method: .get, parameters: ["text": text])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let searchResults = JSON(value)
                    var tmpUsers: [User] = []
                    for (_, userJson) in searchResults["users"] {
                        let user = Mapper<User>().map(JSON: userJson.dictionaryObject!)!
                        tmpUsers.append(user)
                    }
                    userResultsController.users = tmpUsers
                case .failure(let error):
                    print(error)
                }
                
        }
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        search(sender.text!)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

