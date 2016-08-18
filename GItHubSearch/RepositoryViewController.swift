//
//  RepositoryViewController.swift
//  GItHubSearch
//
//  Created by l08084 on 2016/08/18.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit

import SafariServices

class RepositoryViewController: UIViewController, ApplicationContextSettable {
    
    var appContext: ApplicationContext!
    var repository: Repository!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = repository.name
        nameLabel.text = repository.fullName
        urlButton.setTitle(repository.HTMLURL.absoluteString, forState: .Normal)
    }
    
    @IBAction func openURL(sender: AnyObject) {
        let safari = SFSafariViewController(URL: repository.HTMLURL)
        safari.delegate = self
        presentViewController(safari, animated: true, completion: nil)
    }
}

extension RepositoryViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
