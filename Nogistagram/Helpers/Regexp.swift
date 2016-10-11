//
//  Regexp.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/09.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation

class Regexp {
    let internalRegexp: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        do {
            self.internalRegexp = try NSRegularExpression(pattern: pattern, options: [])
        } catch let error as NSError {
            print(error.localizedDescription)
            self.internalRegexp = NSRegularExpression()
        }
    }
    
    func isMatch(_ input: String) -> Bool {
        let nsString = input as NSString
        let matches = self.internalRegexp.matches(in: input, options:[], range:NSMakeRange(0, nsString.length))
        return matches.count > 0
    }
    
    func matches(_ input: String) -> [String]? {
        if self.isMatch(input) {
            let nsString = input as NSString
            let matches = self.internalRegexp.matches(in: input, options: [], range:NSMakeRange(0, nsString.length) )
            var results: [String] = []
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substring(with: matches[i].range) )
            }
            return results
        }
        return nil
    }
}
