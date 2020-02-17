//
//  Constraints.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

extension UIView {
	
	func autolayout() -> Void {
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func topEdgeToSuperview(withInset inset: CGFloat? = nil, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		topAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor, constant: inset ?? 0).isActive = true
	}
	
	func trailingEdgeToSuperview(withInset inset: CGFloat? = nil, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		trailingAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor, constant: inset != nil ? -inset! : 0).isActive = true
	}
	
	func bottomEdgeToSuperview(withInset inset: CGFloat? = nil, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		bottomAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor, constant: inset != nil ? -inset! : 0).isActive = true
	}
	
	func leadingEdgeToSuperview(withInset inset: CGFloat? = nil, safeArea: Bool = false) -> Void {
		guard let superview = self.superview else { return }
		leadingAnchor.constraint(equalTo: safeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor, constant: inset ?? 0).isActive = true
	}
	
	func topEdgeToSafeSuperview(withInset inset: CGFloat? = nil) -> Void {
		topEdgeToSuperview(withInset: inset, safeArea: true)
	}
	
	func trailingEdgeToSafeSuperview(withInset inset: CGFloat? = nil) -> Void {
		trailingEdgeToSuperview(withInset: inset, safeArea: true)
	}
	
	func bottomEdgeToSafeSuperview(withInset inset: CGFloat? = nil) -> Void {
		bottomEdgeToSuperview(withInset: inset, safeArea: true)
	}
	
	func leadingEdgeToSafeSuperview(withInset inset: CGFloat? = nil) -> Void {
		leadingEdgeToSuperview(withInset: inset, safeArea: true)
	}
	
	func horizontalEdgesToSuperview(withInsets insets: UIEdgeInsets? = nil, safeArea: Bool = false) -> Void {
		leadingEdgeToSuperview(withInset: insets?.left, safeArea: safeArea)
		trailingEdgeToSuperview(withInset: insets?.right, safeArea: safeArea)
	}
	
	func horizontalEdgesToSafeSuperview(withInsets insets: UIEdgeInsets? = nil) -> Void {
		horizontalEdgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func verticalEdgesToSuperview(withInsets insets: UIEdgeInsets? = nil, safeArea: Bool = false) -> Void {
		topEdgeToSuperview(withInset: insets?.top, safeArea: safeArea)
		bottomEdgeToSuperview(withInset: insets?.bottom, safeArea: safeArea)
	}
	
	func verticalEdgesToSafeSuperview(withInsets insets: UIEdgeInsets? = nil) -> Void {
		verticalEdgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func edgesToSuperview(withInsets insets: UIEdgeInsets? = nil, safeArea: Bool = false) -> Void {
		horizontalEdgesToSuperview(withInsets: insets, safeArea: safeArea)
		verticalEdgesToSuperview(withInsets: insets, safeArea: safeArea)
	}

	func edgesToSafeSuperview(withInsets insets: UIEdgeInsets? = nil) -> Void {
		edgesToSuperview(withInsets: insets, safeArea: true)
	}
	
	func centerVertically(in view: UIView? = nil) -> Void {
		guard let referenceView = view ?? superview else { return }
		
		NSLayoutConstraint.activate([
			centerYAnchor.constraint(equalTo: referenceView.centerYAnchor)
		])
	}
	
	func centerHorizontally(in view: UIView? = nil) -> Void {
		guard let referenceView = view ?? superview else { return }
		
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: referenceView.centerXAnchor)
		])
	}
	
	func centerBoth(in view: UIView? = nil) -> Void {
		centerVertically(in: view)
		centerHorizontally(in: view)
	}
	
	func fixedSquaredBounds(_ edgeLength: CGFloat) -> Void {
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: edgeLength),
			heightAnchor.constraint(equalTo: widthAnchor)
		])
	}
}
