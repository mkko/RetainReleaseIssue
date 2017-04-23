//
//  ViewController.swift
//  RetainReleaseIssue
//
//  Created by Mikko Välimäki on 17-04-23.
//  Copyright © 2017 Mikko Välimäki. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ViewController: UIViewController {

    var timer: Timer? = nil
    
    let items = [StopResultViewModel()] as [SearchListPresentable]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            switch self.items[0] {
            case let _ as SearchPresentable:
                break
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public protocol SearchListPresentable {
    
}

public protocol SearchPresentable: SearchListPresentable, MKAnnotation {
    
}

class StopResultViewModel: NSObject, SearchPresentable, MKAnnotation {
    
    public var title: String? = ""
    
    public var subtitle: String? = nil
    
    public var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: 1, longitude: 2) }
    
    public var displayName: String? { return "" }
    
    override var debugDescription: String {
        let address = NSString(format: "%p", self)
        return "<StopResultViewModel: \(address)>"
    }
}
