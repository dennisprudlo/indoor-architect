//
//  PopoverInfoViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/17/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class PopoverInfoViewController: UIViewController {
	
	private let labelInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	let titleLabel = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .systemBackground

		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
		titleLabel.textColor = .secondaryLabel
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo:		view.topAnchor,			constant: labelInsets.top),
			titleLabel.trailingAnchor.constraint(lessThanOrEqualTo:	view.trailingAnchor,	constant: -labelInsets.right),
			titleLabel.bottomAnchor.constraint(equalTo:		view.bottomAnchor,		constant: -labelInsets.bottom),
			titleLabel.leadingAnchor.constraint(equalTo: 	view.leadingAnchor,		constant: labelInsets.left),
			titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
		])
    }

	override func viewDidLayoutSubviews() {
		self.preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
}
