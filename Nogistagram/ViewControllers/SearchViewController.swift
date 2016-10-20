//
//  SearchViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/20.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class SearchViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var customButtonBarView: ButtonBarView!
    @IBOutlet weak var customContainerView: UIScrollView!
    
    override func viewDidLoad() {
        self.buttonBarView = customButtonBarView
        self.containerView = customContainerView
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let userResultsController = SeachResultTableViewController(style: .plain, itemInfo: "ピープル")
        let tagResultsController = SeachResultTableViewController(style: .plain, itemInfo: "タグ")
        let spotResultsController = SeachResultTableViewController(style: .plain, itemInfo: "スポット")
        return [userResultsController, tagResultsController, spotResultsController]
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
