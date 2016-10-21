//
//  SearchViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import PagingMenuController

private var pagingControllers: [UIViewController] {
    let userResultsController = SeachResultTableViewController(style: .plain)
    let tagResultsController = SeachResultTableViewController(style: .plain)
    let spotResultsController = SeachResultTableViewController(style: .plain)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

