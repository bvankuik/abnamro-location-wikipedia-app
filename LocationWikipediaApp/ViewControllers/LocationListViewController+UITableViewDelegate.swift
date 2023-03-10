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

        let location = viewModel.locations[indexPath.row]
        os_log("Tapped row with location name ", log: .default, type: .debug, location.name ?? "nil")
        location.open()
    }
}
