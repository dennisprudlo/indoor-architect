//
//  ProjectExplorerSectionHeaderView.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/10/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectExplorerSectionHeaderView: UIView {

	private var sectionInsets = UIEdgeInsets(top: 5, left: 15, bottom: 7, right: 15)
	
	let titleLabel = UILabel()
	
	let chevronIcon = UIImageView()
	
	private var exposeStateChanged: ((Bool) -> Void)?
	
	private var isContentExposed: Bool = true
	
	init(title: String, handler: ((Bool) -> Void)? = nil) {
		super.init(frame: CGRect.zero)
		
		exposeStateChanged = handler
		
		addSubview(titleLabel)
		titleLabel.autolayout()
		titleLabel.edgesToSuperview(withInsets: sectionInsets, safeArea: false)
		
		titleLabel.text									= title
		titleLabel.font									= UIFont.preferredFont(forTextStyle: .title2).bold()
		titleLabel.numberOfLines						= 0
		titleLabel.adjustsFontForContentSizeCategory	= true
		
		let chevronTapView = UIView()
		addSubview(chevronTapView)
		chevronTapView.autolayout()
		chevronTapView.trailingEdgeToSafeSuperview(withInset: sectionInsets.right)
		chevronTapView.verticalEdgesToSuperview()
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChevron(_:)))
		chevronTapView.addGestureRecognizer(gestureRecognizer)
		
		chevronTapView.addSubview(chevronIcon)
		chevronIcon.autolayout()
		chevronIcon.horizontalEdgesToSuperview()
		chevronIcon.centerVertically(in: titleLabel)

		chevronIcon.image							= Icon.chevronUp
		chevronIcon.preferredSymbolConfiguration	= UIImage.SymbolConfiguration(font: titleLabel.font, scale: .small)
		chevronIcon.tintColor						= .tertiaryLabel
		chevronIcon.isUserInteractionEnabled		= true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didTapChevron(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
		isContentExposed = !isContentExposed

		chevronIcon.image = isContentExposed ? Icon.chevronUp : Icon.chevronDown
		exposeStateChanged?(isContentExposed)
	}
}
