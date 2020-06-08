//
//  LeadingIconTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class LeadingIconTableViewCell: UITableViewCell {

	private let viewInset: CGFloat	= 12

	let iconView		= UIImageView()
	let titleLabel		= UILabel()
	
	var defaultSelectionStyle: Bool = false {
		didSet {
			if defaultSelectionStyle {
				selectionStyle = .default
			}
		}
	}
	
	var isEnabled: Bool = true
	
	init(title: String, icon: UIImage?) {
		super.init(style: .value1, reuseIdentifier: nil)
		selectionStyle = .none
		
		addSubview(iconView)
		iconView.autolayout()
		iconView.leadingEdgeToSafeSuperview(withInset: viewInset)
		iconView.centerVertically()
		iconView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		iconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		addSubview(titleLabel)
		titleLabel.autolayout()
		titleLabel.centerVertically()
		titleLabel.trailingAnchor.constraint(equalTo:		trailingAnchor,	constant: -viewInset).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo:		iconView.trailingAnchor, constant: viewInset).isActive = true
		titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
		
		let preferredFont = UIFont.preferredFont(forTextStyle: .body)
		
		iconView.image									= icon
		iconView.preferredSymbolConfiguration			= UIImage.SymbolConfiguration(font: preferredFont, scale: .medium)
		iconView.tintColor								= Color.primary
		
		titleLabel.text									= title
		titleLabel.numberOfLines						= 1
		titleLabel.font									= preferredFont
		titleLabel.adjustsFontForContentSizeCategory	= true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setSelectedState(_ selected: Bool) -> Void {
		if defaultSelectionStyle {
			return
		}
		
		if !isEnabled {
			backgroundColor			= UIColor.secondarySystemGroupedBackground
			titleLabel.textColor	= .secondaryLabel
			iconView.tintColor		= .secondaryLabel
			return
		}
		
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
