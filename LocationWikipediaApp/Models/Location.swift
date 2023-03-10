//
//  LocationModel.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import CoreLocation
import OSLog
import UIKit

struct Location {
    let name: String?
    let coordinate: CLLocationCoordinate2D

    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.wikipediaURLScheme
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(format: "%f", coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(format: "%f", coordinate.longitude))
        ]
        return components.url
    }

    func open() {
        guard let url else {
            os_log("Could not construct Wikipedia URL", log: .default, type: .error)
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            os_log("Opening URL %@", log: .default, type: .debug, url.absoluteString)
            UIApplication.shared.open(url)
        } else {
            os_log("Failed to open URL %@", log: .default, type: .debug, url.absoluteString)
        }
    }
}

extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        let latitude = try values.decode(Double.self, forKey: .lat)
        let longitude = try values.decode(Double.self, forKey: .long)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
