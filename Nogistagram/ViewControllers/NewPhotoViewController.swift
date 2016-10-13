//
//  NewPhotoViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/13.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Fusuma

extension FusumaViewController {
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.fusumaClosed?()
        })
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("next!!!!!!!!!!!!")
    }
}

class NewPhotoViewController: UIViewController, FusumaDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fusumaBaseTintColor = UIColor.gray
        fusumaTintColor = UIColor.black
        fusumaBackgroundColor = UIColor.white
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        self.present(fusuma, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: FusumaDelegate Protocol
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        print("Called when the close button is pressed")
        
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
