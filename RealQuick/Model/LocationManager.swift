import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
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
            permissionsChanged = nil
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func checkPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            checkPermission { permission in
                continuation.resume(returning: permission)
            }
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
    }

    func requestLocation(completion: @escaping (CLLocation) -> Void) {
        locationChanged = completion
        manager.requestLocation()
    }
    
    func getLocation() async -> CLLocation {
        await withCheckedContinuation { continuation in
            requestLocation { location in
                continuation.resume(returning: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            location = locations.first!
            
            if let locationChanged {
                locationChanged(locations.first!)
                self.locationChanged = nil
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
