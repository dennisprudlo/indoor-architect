//
//  ProjectExplorerTableViewCell.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerTableViewCell: UITableViewCell {

	private let cellInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	private let viewInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 12)
	private let iconSize: CGFloat = 20
	
	let selectionView	= UIView()
	let iconView		= UIImageView()
	let titleLabel		= UILabel()
	
	init(title: String, icon: UIImage?) {
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
		
		selectionView.translatesAutoresizingMaskIntoConstraints	= false
		iconView.translatesAutoresizingMaskIntoConstraints		= false
		titleLabel.translatesAutoresizingMaskIntoConstraints	= false
		
		addSubview(selectionView)
		selectionView.addSubview(iconView)
		selectionView.addSubview(titleLabel)
		
		selectionView.layer.cornerRadius = Style.cornerRadius
		selectionView.topAnchor.constraint(equalTo:			topAnchor,		constant: cellInset.top).isActive = true
		selectionView.trailingAnchor.constraint(equalTo:	trailingAnchor,	constant: -cellInset.right).isActive = true
		selectionView.bottomAnchor.constraint(equalTo:		bottomAnchor,	constant: -cellInset.bottom).isActive = true
		selectionView.leadingAnchor.constraint(equalTo:		leadingAnchor,	constant: cellInset.left).isActive = true
		
		let preferredFont = UIFont.preferredFont(forTextStyle: .body)
		
		iconView.image = icon
		iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: preferredFont, scale: .medium)
		iconView.tintColor = Color.primary
		iconView.leadingAnchor.constraint(equalTo:			selectionView.leadingAnchor, constant: viewInset.left).isActive = true
		iconView.centerYAnchor.constraint(equalTo: 			selectionView.centerYAnchor).isActive = true
		
		titleLabel.text = title
		titleLabel.numberOfLines = 0
		titleLabel.font = preferredFont
		titleLabel.adjustsFontForContentSizeCategory = true
		titleLabel.topAnchor.constraint(equalTo:			selectionView.topAnchor,		constant: viewInset.top).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo:		selectionView.trailingAnchor,	constant: -viewInset.right).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo:			selectionView.bottomAnchor,		constant: -viewInset.bottom).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo:		iconView.trailingAnchor,		constant: cellInset.left).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setSelectedState(_ selected: Bool) -> Void {
		if selected {
			selectionView.backgroundColor = Color.lightStyleCellBackground
		} else {
			selectionView.backgroundColor = backgroundColor
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
