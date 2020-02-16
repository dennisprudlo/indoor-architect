//
//  ScrollViewController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/16/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

	let scrollView			= UIScrollView()
	let scrollContentView	= UIView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addSubview(scrollView)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.topAnchor.constraint(equalTo:		view.topAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo:	view.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo:		view.bottomAnchor).isActive = true
		scrollView.leadingAnchor.constraint(equalTo:	view.leadingAnchor).isActive = true
		
		scrollView.addSubview(scrollContentView)
    
		scrollContentView.translatesAutoresizingMaskIntoConstraints = false
		scrollContentView.topAnchor.constraint(equalTo:			scrollView.topAnchor).isActive = true
		scrollContentView.trailingAnchor.constraint(equalTo:	scrollView.trailingAnchor).isActive = true
		scrollContentView.bottomAnchor.constraint(equalTo:		scrollView.bottomAnchor).isActive = true
		scrollContentView.leadingAnchor.constraint(equalTo:		scrollView.leadingAnchor).isActive = true
		
		scrollContentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
	}

}
