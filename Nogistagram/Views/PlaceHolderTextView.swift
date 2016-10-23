//
//  PlaceHolderTextView.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/21.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceHolderTextView: UITextView {
    
    private var placeHolderLable: UILabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        initialize()
    }
    
    func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange(textView:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        placeHolderLable = UILabel(frame: CGRect(x: 8, y: 5, width: self.bounds.size.width - 16, height: 0))
        placeHolderLable.font = UIFont.systemFont(ofSize: 14.0)
        placeHolderLable.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.addSubview(placeHolderLable)
    }
    
    @IBInspectable var placeHolder: String = "Place Holder" {
        didSet {
            self.placeHolderLable.text = placeHolder
            self.placeHolderLable.sizeToFit()
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = UIColor.lightGray {
        didSet {
            self.placeHolderLable.textColor = placeHolderColor
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    func textFieldDidChange(textView: PlaceHolderTextView) {
        placeHolderLable.isHidden = (text.characters.count > 0) ? true : false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
