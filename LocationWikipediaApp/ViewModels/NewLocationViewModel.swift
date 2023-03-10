//
//  NewLocationViewModel.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 10/03/2023.
//

import CoreLocation

struct NewLocationViewModel {
    var latitudeString: String = ""
    var longitudeString: String = ""
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: Double(latitudeString) ?? Double.nan,
            longitude: Double(longitudeString) ?? Double.nan
        )
    }

    var location: Location {
        Location(name: nil, coordinate: coordinate)
    }
}
