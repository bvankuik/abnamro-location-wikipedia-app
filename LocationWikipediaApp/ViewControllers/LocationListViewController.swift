//
//  LocationListViewController.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import OSLog
import UIKit

class LocationListViewController: UIViewController {
    private static let cellIdentifier = "LocationListTableViewCell"
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.allowsSelection = false

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()

        view.addSubview(tableView)
        view.addSubview(spinner)

        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        view.addConstraints(constraints)

        view.backgroundColor = UIColor.systemBackground
        title = "Locations"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            spinner.startAnimating()
            await LocationListService.shared.refresh()
            refreshView()
        }
    }

    private func refreshView() {
        switch LocationListService.shared.mode {
        case .loading:
            spinner.startAnimating()
        case .success:
            spinner.stopAnimating()
            tableView.reloadData()
        case .error:
            spinner.stopAnimating()
        }
    }
}

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

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .success(locationList) = LocationListService.shared.mode else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = locationList.locations[indexPath.row].name ?? "(Unknown location)"
        return cell
    }
}
