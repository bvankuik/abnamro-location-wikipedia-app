//
//  LocationListViewController+UITableViewDataSource.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 09/03/2023.
//

import UIKit

extension LocationListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.locations.count
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.locations[indexPath.row].name ?? "(Unknown location)"
        return cell
    }
}
