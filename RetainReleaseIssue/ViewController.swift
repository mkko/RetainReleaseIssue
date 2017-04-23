//
//  ViewController.swift
//  RetainReleaseIssue
//
//  Created by Mikko Välimäki on 17-04-23.
//  Copyright © 2017 Mikko Välimäki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let items = [SomeClass()] as [BaseProtocol]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doTheSwitch(items[0])
        doTheSwitch(items[0])
    }
    
    func doTheSwitch(_ item: BaseProtocol) {
        switch item {
        case let _ as SubProtocol:
            break
        default:
            break
        }
    }
}

public protocol SomeObjectProtocol : NSObjectProtocol { }

public protocol BaseProtocol { }

public protocol SubProtocol: BaseProtocol, SomeObjectProtocol { }

class SomeClass: NSObject, SubProtocol { }
