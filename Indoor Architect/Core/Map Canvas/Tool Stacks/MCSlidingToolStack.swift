//
//  MCSlidingToolStack.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCSlidingInfoToolStack: MCToolStack {
	
	/// The default animation speed when showing and hiding the tool stack
	private static let animationSpeed: TimeInterval				= 0.1
	
	/// The default curve used for the animation
	private static let animationCurve: UIView.AnimationOptions	= .curveEaseInOut
	
	/// The default time a displayed text remains on the canvas until the tool stack hides itself
	private static let displayTime: TimeInterval				= 2
	
	/// The default time a displayed text remains on the canvas until the tool stack hides itself
	/// when there are more texts to show waiting in the queue
	private static let displayTimeInQueue: TimeInterval			= 1.6
	
	/// A reference to the stacks top constraint anchor. It is used to animate the tool stack up and down
	var topConstraint: NSLayoutConstraint?
	
	/// Returns the constant value for the top constraint that is needed to completely hide the tool stack
	private var hiddenConstant: CGFloat {
		let currentYPosition	= frame.origin.y
		let currentHeight		= frame.height
		return -(currentYPosition + currentHeight)
	}
	
	/// The tool stack label item which is used to display the text
	let infoItem = MCLabelToolStackItem(isDefault: true)
	
	/// Defines whether the sliding animation is currently playing
	private var isInAnimation: Bool = false
	
	/// The queue with all texts to display
	private var animationQueue: [(title: String, label: String?)] = []
	
	/// Whether the initial layout of the subviews has been happened
	private var initialized: Bool = false
	
	override init(forAxis axis: NSLayoutConstraint.Axis) {
		super.init(forAxis: axis)
		
		addItem(infoItem)
		
		//
		// Disable user interaction so a tap on the label doesnt show the selected background indicator
		infoItem.isUserInteractionEnabled = false
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func reset() {
		infoItem.setTitle(nil)
	}
	
	func slideOut(immediately: Bool = false, completion: ((Bool) -> Void)? = nil) -> Void {
		animate(show: false, completion: completion, duration: immediately ? 0 : MCSlidingInfoToolStack.animationSpeed)
	}
	
	func slideIn(withText text: String, withLabel label: String? = nil) -> Void {
		
		if let label = label {
			infoItem.setTitle(text)
			infoItem.setLabelTitle(label: label, title: text)
		} else {
			infoItem.setAttributedTitle(nil)
			infoItem.setTitle(text)
		}

		//
		// Resize the tool stack to fit the labels size
		layoutIfNeeded()
		
		//
		// Animate the label
		animate(show: true)
	}
	
	func display(text: String, withLabel label: String? = nil, remain: TimeInterval = MCSlidingInfoToolStack.displayTime) -> Void {
		
		//
		// If some info is currently in animation we add the text to the queue
		// to display it later on
		if isInAnimation {
			animationQueue.append((title: text, label: label))
			return
		}
		
		isInAnimation = true
		
		slideIn(withText: text, withLabel: label)
		DispatchQueue.main.asyncAfter(deadline: .now() + remain) {
			self.slideOut(immediately: false) { (success) in
				self.isInAnimation = false
				if (self.animationQueue.count > 0) {
					let nextText = self.animationQueue.removeFirst()
					self.display(text: nextText.title, withLabel: nextText.label, remain: MCSlidingInfoToolStack.displayTimeInQueue)
				}
			}
		}
	}
	
	private func animate(show: Bool, completion: ((Bool) -> Void)? = nil, duration: TimeInterval = MCSlidingInfoToolStack.animationSpeed) -> Void {
		topConstraint?.constant	= show ? 0 : hiddenConstant
		
		UIView.animate(
			withDuration:	duration,
			delay:			0,
			options:		MCSlidingInfoToolStack.animationCurve,
			animations: {
				self.superview?.layoutIfNeeded()
			},
			completion: completion
		)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if !initialized {
			topConstraint?.constant = hiddenConstant
			initialized = true
		}
	}
}
