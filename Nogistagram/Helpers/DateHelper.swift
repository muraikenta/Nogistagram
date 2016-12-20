//
//  DateHelper.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/11/03.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation

class DateHelper {
    static func date(fromString: String, format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: fromString)
    }
}
