//
//  Constraints.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

extension UIView {
	
	func horizontalEdgesToSuperview(withInsets insets: UIEdgeInsets?, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		let edgeInsets = insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		
		NSLayoutConstraint.activate([
			trailingAnchor.constraint(equalTo:	safeArea ? superview.safeAreaLayoutGuide.trailingAnchor	: superview.trailingAnchor,	constant: -edgeInsets.right),
			leadingAnchor.constraint(equalTo:	safeArea ? superview.safeAreaLayoutGuide.leadingAnchor	: superview.leadingAnchor,	constant: edgeInsets.left)
		])
	}
	
	func horizontalEdgesToSafeSuperview(withInsets insets: UIEdgeInsets?) -> Void {
		horizontalEdgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func verticalEdgesToSuperview(withInsets insets: UIEdgeInsets?, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		let edgeInsets = insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo:		safeArea ? superview.safeAreaLayoutGuide.topAnchor		: superview.topAnchor,		constant: edgeInsets.top),
			bottomAnchor.constraint(equalTo:	safeArea ? superview.safeAreaLayoutGuide.bottomAnchor	: superview.bottomAnchor,	constant: -edgeInsets.bottom)
		])
	}
	
	func verticalEdgesToSafeSuperview(withInsets insets: UIEdgeInsets?) -> Void {
		verticalEdgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func edgesToSuperview(withInsets insets: UIEdgeInsets?, safeArea: Bool = false) -> Void {
		horizontalEdgesToSuperview(withInsets: insets, safeArea: safeArea)
		verticalEdgesToSuperview(withInsets: insets, safeArea: safeArea)
	}

	func edgesToSafeSuperview(withInsets insets: UIEdgeInsets?) -> Void {
		edgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func centerVertically(in view: UIView?) -> Void {
		guard let referenceView = view ?? superview else { return }
		
		NSLayoutConstraint.activate([
			centerYAnchor.constraint(equalTo: referenceView.centerYAnchor)
		])
	}
	
	func centerHorizontically(in view: UIView?) -> Void {
		guard let referenceView = view ?? superview else { return }
		
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: referenceView.centerXAnchor)
		])
	}
}
