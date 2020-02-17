//
//  ProjectExplorerSectionHeaderView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerSectionHeaderView: UIView {

	private var sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15)
	
	let titleLabel = UILabel()
	
	init(title: String) {
		super.init(frame: CGRect.zero)
		
		backgroundColor = .systemBackground
		addSubview(titleLabel)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = title
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
		titleLabel.numberOfLines = 0
		titleLabel.adjustsFontForContentSizeCategory = true
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo:		topAnchor,		constant: sectionInsets.top),
			titleLabel.trailingAnchor.constraint(equalTo:	trailingAnchor,	constant: -sectionInsets.right),
			titleLabel.bottomAnchor.constraint(equalTo:		bottomAnchor,	constant: -sectionInsets.bottom),
			titleLabel.leadingAnchor.constraint(equalTo:	leadingAnchor,	constant: sectionInsets.left)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
