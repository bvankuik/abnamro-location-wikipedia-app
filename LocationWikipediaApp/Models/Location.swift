//
//  LocationModel.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import CoreLocation
import OSLog
import UIKit

struct Location: Decodable {
    let name: String?
    let lat: Double
    let long: Double
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.wikipediaURLScheme
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(format: "%f", lat)),
            URLQueryItem(name: "longitude", value: String(format: "%f", long))
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
