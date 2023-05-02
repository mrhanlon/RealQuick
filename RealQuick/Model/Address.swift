//
//  Address.swift
//  Real Quick
//
//  Created by Matthew Hanlon on 5/1/23.
//

import Foundation
import CoreLocation

struct Address {
    private let place: CLPlacemark
    
    init(_ place: CLPlacemark) {
        self.place = place
    }
    
    var description: String {
        return [place.subThoroughfare, place.thoroughfare, place.locality, place.administrativeArea, place.postalCode]
            .compactMap({ $0 })
            .joined(separator: " ")
    }
    
    static func resolve(_ latitude: Double, _ longitude: Double) async -> Address? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude))
            if !placemarks.isEmpty {
                return Address(placemarks.first!)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func resolve(_ coordinate: CLLocationCoordinate2D) async -> Address? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            if !placemarks.isEmpty {
                return Address(placemarks.first!)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
