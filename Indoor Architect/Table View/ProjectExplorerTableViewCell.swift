//
//  ProjectExplorerTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerTableViewCell: UITableViewCell {

	private let viewInset: CGFloat	= 12
	private let iconSize: CGFloat	= 20
	
	let iconView		= UIImageView()
	let titleLabel		= UILabel()
	
	init(title: String, icon: UIImage?) {
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
		
		addSubview(iconView)
		iconView.autolayout()
		iconView.leadingEdgeToSafeSuperview(withInset: viewInset)
		iconView.centerVertically()
		
		addSubview(titleLabel)
		titleLabel.autolayout()
		titleLabel.topAnchor.constraint(equalTo:			topAnchor,		constant: viewInset).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo:		trailingAnchor,	constant: -viewInset).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo:			bottomAnchor,	constant: -viewInset).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo:		iconView.trailingAnchor, constant: viewInset).isActive = true
		
		let preferredFont = UIFont.preferredFont(forTextStyle: .body)
		
		iconView.image									= icon
		iconView.preferredSymbolConfiguration			= UIImage.SymbolConfiguration(font: preferredFont, scale: .medium)
		iconView.tintColor								= Color.primary
		
		titleLabel.text									= title
		titleLabel.numberOfLines						= 0
		titleLabel.font									= preferredFont
		titleLabel.adjustsFontForContentSizeCategory	= true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setSelectedState(_ selected: Bool) -> Void {
		if selected {
			backgroundColor			= Color.primary
			titleLabel.textColor	= .white
			iconView.tintColor		= .white
		} else {
			backgroundColor			= UIColor.secondarySystemGroupedBackground
			titleLabel.textColor	= .label
			iconView.tintColor		= Color.primary
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		setSelectedState(selected)
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		setSelectedState(highlighted)
	}
}
