//
//  ReceiverViewController.swift
//  demo
//
//  Created by Pablo Cambre on 9/26/16.
//  Copyright © 2016 Pablo Cambre. All rights reserved.
//

import UIKit

class ReceiverViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    static let storyboardIdentifier = "ReceiverViewController"
    
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = message
    }

}
