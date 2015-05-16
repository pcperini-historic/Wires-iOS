//
//  RecordingViewController.swift
//  Wires
//
//  Created by Patrick Perini on 5/1/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit
import Recorder

class RecordingViewController: UIViewController {
    @IBOutlet var recordingView: UIView?
    var recorder: Recorder?
    
    override func viewDidLoad() {
        self.recorder = Recorder()
        self.recorder?.view = self.recordingView
    }
    
    override func viewDidAppear(animated: Bool) {
        self.recorder?.start()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.recorder?.stop()
        }
    }
}