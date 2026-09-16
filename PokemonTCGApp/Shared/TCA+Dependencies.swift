import Foundation
import ComposableArchitecture
import ComposableCoreLocation

extension NetworkManager: DependencyKey {
    static let liveValue = NetworkManager()
}

extension DependencyValues {
  var networkManager: NetworkManager {
    get { self[NetworkManager.self] }
    set { self[NetworkManager.self] = newValue }
  }
}

extension LocationManager: DependencyKey {
    public static let liveValue = LocationManager.live
}

extension DependencyValues {
  var locationManager: LocationManager {
    get { self[LocationManager.self] }
    set { self[LocationManager.self] = newValue }
  }
}
