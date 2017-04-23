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

@objc public protocol BNLocating {
    
    var address: AddressInfo? { get }
    
    var displayName: String? { get }
    
    var coordinate: CLLocationCoordinate2D { get }
    
}


public protocol SearchListPresentable {
    
    var searchResultTitle: String { get }
    
    var searchResultSubtitle: String? { get }
    
}

public protocol MapAnnotation: MKAnnotation {
    
}

public protocol SearchPresentable: SearchListPresentable, MapAnnotation {
    
}

class StopResultViewModel: NSObject, SearchPresentable, BNLocating, MKAnnotation {
    
    // MARK: SearchPresentable
    
    open var searchResultTitle: String { return "" }
    
    open let searchResultSubtitle: String? = nil
    
    public var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: 1, longitude: 2) }
    
    // Title and subtitle for use by selection UI.
    public var title: String? = ""
    public var subtitle: String? = nil
    
    // MARK: BNLocatable
    
    public let address: AddressInfo? = nil
    
    public var displayName: String? { return "" }
    
    override var debugDescription: String {
        let address = NSString(format: "%p", self)
        return "<StopResultViewModel: \(address)>"
    }
}

@objc(AddressInfo) open class AddressInfo: NSObject {
    
    let postalAddress: CNPostalAddress
    
    open var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    public init(address: CNPostalAddress) {
        self.postalAddress = address
    }
    
    open var addressDictionary: [String: String] {
        return [:]
    }
    
    open func asString() -> String {
        return ""
    }
    
    open var addressString: String { return "" }
    
    // TODO: This belongs to elsewhere.
    open func geocodeCoordinateWithCompletion(_ completionHandler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressDictionary(self.addressDictionary, completionHandler: { placemarks, error in
            self.updateCoordinate(placemarks)
            completionHandler(placemarks, error)
        })
    }
    
    open func updateCoordinate(_ placemarks: [CLPlacemark]?) {
        if let placemarks = placemarks, let placemark = placemarks.first {
            self.coordinate = placemark.location?.coordinate ?? kCLLocationCoordinate2DInvalid
        }
    }
}
