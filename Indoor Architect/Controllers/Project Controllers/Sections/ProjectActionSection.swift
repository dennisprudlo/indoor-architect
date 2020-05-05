//
//  ProjectActionSection.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 2/29/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit

class ProjectActionSection: ProjectSection {
	
	let editIndoorMapButton = UIButton(type: .system)
	let exportArchiveButton = UIButton(type: .system)
	
	let buttonSet = ButtonSetTableViewCell(buttons: [])
	
	let iconSpacing: CGFloat = 15
	
	override init() {
		super.init()
		
		editIndoorMapButton.setTitle(Localizable.Project.editIndoorMap, for: .normal)
		editIndoorMapButton.backgroundColor = Color.indoorMapEdit
		editIndoorMapButton.setImage(Icon.map, for: .normal)
		editIndoorMapButton.tintColor = .white
		editIndoorMapButton.addTarget(self, action: #selector(didTapEditIndoorMap), for: .touchUpInside)
		editIndoorMapButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: iconSpacing / 2)
		editIndoorMapButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: iconSpacing / 2, bottom: 0, right: 0)
		
		exportArchiveButton.setTitle(Localizable.Project.exportImdfArchive, for: .normal)
		exportArchiveButton.backgroundColor = Color.indoorMapExport
		exportArchiveButton.setImage(Icon.download, for: .normal)
		exportArchiveButton.tintColor = .white
		exportArchiveButton.addTarget(self, action: #selector(didTapExportArchive), for: .touchUpInside)
		exportArchiveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: iconSpacing / 2)
		exportArchiveButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: iconSpacing / 2, bottom: 0, right: 0)
		
		buttonSet.addButtons([editIndoorMapButton, exportArchiveButton])
		
		cells.append(buttonSet)
	}
	
	@objc private func didTapEditIndoorMap(_ sender: UIButton) -> Void {
		(MapCanvasViewController()).presentForSelectedProject()
	}
	
	@objc private func didTapExportArchive(_ sender: UIButton) -> Void {
		print("export")
	}
}
