//
//  ViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log("ViewController is moving from disappeared to appearing state")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log("ViewController moved from appearing to appeared state")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        log("ViewController's view is going to layout it subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        log("ViewController's view has laid it subviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log("ViewController is moving from appeared to disappearing state")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        log("ViewController moved from disappearing to disappeared state")
    }


}

