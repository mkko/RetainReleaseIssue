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
    
    let items = [StopResultViewModel(result: StopSearchResultItem(stopID: "123", displayName: "123", coordinate: CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0)))] as [SearchListPresentable]

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

public protocol SearchedItem {
    
    func isEqualToSearchItem(another: SearchedItem) -> Bool
    
}

public protocol SearchListPresentable {
    
    var searchResultTitle: String { get }
    
    var searchResultSubtitle: String? { get }
    
    var searchedItem: SearchedItem { get }
    
}

public protocol MapAnnotation: MKAnnotation {
    
}

public protocol SearchPresentable: SearchListPresentable, MapAnnotation {
    
}

open class StopSearchResultItem {
    
    open let stopID: String
    
    open let displayName: String
    
    open let coordinate: CLLocationCoordinate2D
    
    public init(stopID: String, displayName: String, coordinate: CLLocationCoordinate2D) {
        self.stopID = stopID
        self.displayName = displayName
        self.coordinate = coordinate
    }
}

extension StopSearchResultItem: SearchedItem {
    
    public func isEqualToSearchItem(another: SearchedItem) -> Bool {
        if let another = another as? StopSearchResultItem {
            return another.stopID == self.stopID
        }
        return false
    }
}

class StopResultViewModel: NSObject, SearchPresentable, BNLocating, MKAnnotation {
    
    private let result: StopSearchResultItem
    
    private let debugTitle: String
    
    init(result: StopSearchResultItem) {
        self.result = result
        self.debugTitle = result.displayName
    }
    
    // MARK: SearchPresentable
    
    open var searchResultTitle: String { return self.result.displayName }
    
    open let searchResultSubtitle: String? = nil
    
    public var coordinate: CLLocationCoordinate2D { return self.result.coordinate }
    
    // Title and subtitle for use by selection UI.
    public var title: String? {
        return result.displayName
    }
    
    public var subtitle: String? { return nil }
    
    // MARK: BNLocatable
    
    public let address: AddressInfo? = nil
    
    public var displayName: String? { return self.result.displayName }
    
    public var searchedItem: SearchedItem { return self.result }
    
    //    deinit {
    //
    ////        var s = self
    ////        withUnsafePointer(to: &s) { p in
    ////            //print(" str value \(str) has address: \($0)")
    ////            print("StopResultViewModel(\(p)).deinit - \(self.debugTitle)")
    ////        }
    //
    ////        print("StopResultViewModel(\(self.debugTitle)).deinit")
    //        let desc = self.debugDescription
    //        print("--> deinit: \(desc)")
    //    }
    
    override var debugDescription: String {
        let address = NSString(format: "%p", self)
        return "<StopResultViewModel: \(address), \(self.debugTitle)>"
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
