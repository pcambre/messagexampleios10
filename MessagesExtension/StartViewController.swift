//
//  StartViewController.swift
//  demo
//
//  Created by Pablo Cambre on 9/26/16.
//  Copyright © 2016 Pablo Cambre. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    static let storyboardIdentifier = "StartViewController"
    weak var delegate: StartViewControllerDelegate?
    
    @IBAction func startMessageSender(_: AnyObject) {
        delegate?.startMessageSenderSelected(self)
    }
    
}

protocol StartViewControllerDelegate: class {
    func startMessageSenderSelected(_ controller: StartViewController)
}
