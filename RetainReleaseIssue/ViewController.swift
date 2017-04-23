//
//  ViewController.swift
//  RetainReleaseIssue
//
//  Created by Mikko Välimäki on 17-04-23.
//  Copyright © 2017 Mikko Välimäki. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    var timer: Timer? = nil
    
    let items = [StopResultViewModel()] as [BogusProtocol]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        doTheSwitch(items[0])
        doTheSwitch(items[0])
    }
    
    private func doTheSwitch(_ item: BogusProtocol) {
        switch item {
        case let _ as SubBogusProtocol:
            break
        default:
            break
        }
    }
}

public protocol SomeObjectProtocol : NSObjectProtocol {
    
}

public protocol BogusProtocol {
    
}

public protocol SubBogusProtocol: BogusProtocol, SomeObjectProtocol {
    
}

class StopResultViewModel: NSObject, SubBogusProtocol {
    
}
