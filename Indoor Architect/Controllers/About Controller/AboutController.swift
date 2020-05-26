//
//  AboutController.swift
//  Indoor Architect
//
//  Created by Dennis Prudlo on 5/26/20.
//  Copyright © 2020 Dennis Prudlo. All rights reserved.
//

import UIKit
import MessageUI

class AboutController: IATableViewController, MFMailComposeViewControllerDelegate {

	let privacyPolicyCell	= LeadingIconTableViewCell(title: Localizable.About.privacyPolicy,	icon: UIImage(systemName: "hand.raised.fill"))
	let developersSiteCell	= LeadingIconTableViewCell(title: Localizable.About.developersSite,	icon: UIImage(systemName: "globe"))
	let reportIssueCell		= LeadingIconTableViewCell(title: Localizable.About.reportIssue, 	icon: UIImage(systemName: "exclamationmark.bubble.fill"))
	
	override func viewDidLoad() {
		super.viewDidLoad()

		privacyPolicyCell.accessoryType				= .disclosureIndicator
		privacyPolicyCell.defaultSelectionStyle		= true
		
		developersSiteCell.accessoryType			= .disclosureIndicator
		developersSiteCell.defaultSelectionStyle	= true
		
		reportIssueCell.accessoryType				= .disclosureIndicator
		reportIssueCell.defaultSelectionStyle		= true
		
		appendSection(cells: [AboutTableViewCell()])
		.appendSection(cells: [
			UITableViewCell.fixed(title: Localizable.About.supportedImdf, detail: Application.imdfVersion)
		])
		.appendSection(cells: [privacyPolicyCell, developersSiteCell, reportIssueCell])
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return
		}
		
		if cell == privacyPolicyCell {
			if let url = URL(string: "https://dennisprudlo.com/privacy") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		if cell == developersSiteCell {
			if let url = URL(string: "https://dennisprudlo.com") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		if cell == reportIssueCell {
			
			//
			// Alert that no mail is configures
			guard MFMailComposeViewController.canSendMail() else {
				let alertController = UIAlertController(title: Localizable.About.noMailConfigured, message: Localizable.About.noMailConfiguredText, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: Localizable.General.ok, style: .default, handler: nil))
				present(alertController, animated: true, completion: nil)
				return
			}
			
			let ap = UIBarButtonItem.appearance(whenContainedInInstancesOf: [MFMailComposeViewController.self])
			ap.tintColor = .red
			
			let mailComposer = MFMailComposeViewController()
			mailComposer.mailComposeDelegate = self
			mailComposer.setToRecipients(["mail@dennisprudlo.com"])
			mailComposer.setSubject("Indoor Architect | Report an Issue")
			mailComposer.setMessageBody("""
				<br><br><br><br><br><br>
				<b>Details</b><br>
				<i>\(Application.versionIdentifier)</i>
			""", isHTML: true)
			
			present(mailComposer, animated: true, completion: nil)
		}
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
