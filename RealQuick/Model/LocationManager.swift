import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var address: String?
    @Published var location: CLLocationCoordinate2D?
    @Published var locationEnabled = false
    
    private var permissionsChanged: ((Bool) -> Void)?
    private var locationChanged: ((CLLocation) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        locationEnabled = manager.authorizationStatus == .authorizedWhenInUse
    }
    
    func checkPermission() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationEnabled = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func checkPermission(completion: @escaping (Bool) -> Void) {
        permissionsChanged = completion
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationEnabled = true
            completion(true)
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
    }

    func requestLocation(completion: @escaping (CLLocation) -> Void) {
        locationChanged = completion
        manager.requestLocation()
    }
    
    private func setAddress(_ placemark: CLPlacemark) {
        address = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode]
            .compactMap({ $0 })
            .joined(separator: " ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            if let locationChanged {
                locationChanged(locations.first!)
            }
            
            location = locations.first!.coordinate
            geocoder.reverseGeocodeLocation(locations.first!) { (placemarks, error) in
                guard error == nil && placemarks!.count > 0 else { return }
                self.setAddress(placemarks!.first!)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors here
        print("[LocationManager] ERROR: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationEnabled = true
        default:
            locationEnabled = false
        }
        
        if let permissionsChanged {
            permissionsChanged(locationEnabled)
        }
    }

}
