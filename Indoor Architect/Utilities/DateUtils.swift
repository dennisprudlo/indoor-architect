//
//  DateUtils.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import Foundation

class DateUtils {
	
	/// Creates an ISO8601 date string from a date instance
	/// - Parameters:
	///   - date: The date instance to get the date from
	///   - withTime: Whether the time should be included
	static func iso8601(for date: Date, withTime: Bool = true) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = withTime ? "yyyy-MM-dd'T'HH:mm:ss" : "YYYY-MM-DD"
		return formatter.string(from: date)
	}
	
	/// Creates a `Date` instance from a given ISO8601 date string
	/// - Parameters:
	///   - string: The date string that should be parsed
	///   - withTime: Whether the date string includes a time component
	static func instance(iso8601 string: String, withTime: Bool = true) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = withTime ? "yyyy-MM-dd'T'HH:mm:ss" : "YYYY-MM-DD"
		return formatter.date(from: string)
	}
}
