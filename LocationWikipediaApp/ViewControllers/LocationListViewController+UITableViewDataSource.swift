//
//  LocationListViewController+UITableViewDataSource.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 09/03/2023.
//

import UIKit

extension LocationListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard case let .success(locationList) = LocationListService.shared.mode else {
            return 0
        }
        return locationList.locations.count
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .success(locationList) = LocationListService.shared.mode else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = locationList.locations[indexPath.row].name ?? "(Unknown location)"
        return cell
    }
}
