//
//  DateUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class DateUtils {
	
	static func iso8601(for date: Date, withTime: Bool = true) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = withTime ? "yyyy-MM-dd'T'HH:mm:ss" : "YYYY-MM-DD"
		return formatter.string(from: date)
	}
	
	static func instance(iso8601 string: String, withTime: Bool = true) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = withTime ? "yyyy-MM-dd'T'HH:mm:ss" : "YYYY-MM-DD"
		return formatter.date(from: string)
	}
}
