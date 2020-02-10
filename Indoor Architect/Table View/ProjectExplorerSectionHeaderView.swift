//
//  ProjectExplorerSectionHeaderView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerSectionHeaderView: UIView {

	private var sectionInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
	private let topOffset: CGFloat = 25
	
	let titleLabel = UILabel()
	
	init(title: String, firstSection: Bool = true) {
		super.init(frame: CGRect.zero)
		addSubview(titleLabel)
		
		if !firstSection {
			sectionInsets.top = topOffset
		}
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = title
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
		titleLabel.numberOfLines = 0
		titleLabel.adjustsFontForContentSizeCategory = true
		
		titleLabel.topAnchor.constraint(equalTo:		topAnchor,		constant: sectionInsets.top).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo:	trailingAnchor,	constant: -sectionInsets.right).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo:		bottomAnchor,	constant: -sectionInsets.bottom).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo:	leadingAnchor,	constant: sectionInsets.left).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
