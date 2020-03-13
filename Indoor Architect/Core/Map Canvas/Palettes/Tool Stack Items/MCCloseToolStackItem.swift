//
//  MCCloseToolStackItem.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/22/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class MCCloseToolStackItem: MCToolStackItem, MCToolStackItemDelegate {
	
	override init(isDefault: Bool = false) {
		super.init(isDefault: isDefault)
		super.delegate = self
		
		imageView.image = Icon.toolClose
		preventIndicatingSelection = true
		
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: MCToolStackItem.toolStackItemSize),
			heightAnchor.constraint(equalTo: widthAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func toolStackItem(_ toolStackItem: MCToolStackItem, registeredTapFrom tapGestureRecognizer: UITapGestureRecognizer) {
		MapCanvasViewController.shared.canvas.toolPalette.closeToolStack.showInfoLabel(withText: "Saving...")
		do {
			let project: IMDFProject! = MapCanvasViewController.shared.project
			try project.save()
			try project.imdfArchive.save(.anchor)
			
			MapCanvasViewController.shared.canvas.toolPalette.closeToolStack.hideInfoLabel()
			MapCanvasViewController.shared.dismiss(animated: true, completion: nil)
		} catch {
			print("an error occured while trying to save the project")
		}
	}
}
