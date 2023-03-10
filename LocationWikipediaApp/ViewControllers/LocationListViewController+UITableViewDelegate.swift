//
//  LocationListViewController+UITableViewDelegate.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 09/03/2023.
//

import OSLog
import UIKit

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard case let .success(locationList) = LocationListService.shared.mode else {
            os_log("Tapped row  %d but service was not succesful", log: .default, type: .debug, indexPath.row)
            return
        }

        let location = locationList.locations[indexPath.row]
        os_log("Tapped row  %d with location name ", log: .default, type: .debug, location.name ?? "nil")

        var components = URLComponents()
        components.scheme = Constants.wikipediaURLScheme
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(format: "%f", location.lat)),
            URLQueryItem(name: "longitude", value: String(format: "%f", location.long))
        ]

        guard let url = components.url else {
            os_log("Could not contstruct Wikipedia URL", log: .default, type: .error)
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
