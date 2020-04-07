//
//  SecondViewController.swift
//  omnicha-ios
//
//  Created by Eason on 2019/11/29.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit
import OmniSegment

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        OmniSegmentService.sharedInstance.setScreenName(screenName: "SecondViewControllerScreen", screenClass: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        OmniSegmentService.sharedInstance.logEvent(hit_type: HitType.EVENT, dict: [PayloadType.EVENT_LABEL : ["123" : "abc",
                                                                                                          "321" : 123],
                                                                               PayloadType.EVENT_ACTION : EventActionType.CLICK_MENU,
                                                                               PayloadType.EVENT_CATEGORY : "TestCategory",
                                                                               PayloadType.EVENT_VALUE : 123])
    }
    @IBAction func finishAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
