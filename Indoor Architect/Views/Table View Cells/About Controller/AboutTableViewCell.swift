//
//  AboutTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

	let inset: CGFloat = 32
	
	let titleLabel		= UILabel()
	let subtitleLabel	= UILabel()
	
	init() {
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
		
		backgroundColor = .clear
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(subtitleLabel)
		
		titleLabel.autolayout()
		titleLabel.horizontalEdgesToSafeSuperview(withInsets: UIEdgeInsets.h(left: inset, right: inset))
		titleLabel.centerHorizontally()
		titleLabel.topEdgeToSafeSuperview(withInset: inset)
		
		titleLabel.text				= Localizable.About.title
		titleLabel.textColor		= Color.primary
		titleLabel.textAlignment	= .center
		titleLabel.font				= UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize * 1.5, weight: .black)
		
		subtitleLabel.autolayout()
		subtitleLabel.horizontalEdgesToSafeSuperview(withInsets: UIEdgeInsets.h(left: inset, right: inset))
		subtitleLabel.centerHorizontally()
		NSLayoutConstraint.activate([
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
		])
		subtitleLabel.bottomEdgeToSafeSuperview(withInset: inset)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		
		subtitleLabel.text				= "\(Localizable.About.version)\n\(dateFormatter.string(from: Date()))"
		subtitleLabel.textColor			= .label
		subtitleLabel.textAlignment		= .center
		subtitleLabel.numberOfLines		= 0
		subtitleLabel.font				= UIFont.preferredFont(forTextStyle: .body)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
