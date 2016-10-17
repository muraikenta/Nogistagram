//
//  NewPostDetailViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/14.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire

class NewPostDetailViewController: UIViewController {
    
    var image = UIImage()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func loadView() {
        if let view = UINib(nibName: "NewPostDetailViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
            self.imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        let imageData: Data = UIImagePNGRepresentation(image)!
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(self.textView.text!.data(using: String.Encoding.utf8)!, withName: "body")
                multipartFormData.append(imageData, withName: "image_binary")
            },
            to: "\(Constant.Api.root)/posts",
            headers: SessionHelper.authDict(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
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
