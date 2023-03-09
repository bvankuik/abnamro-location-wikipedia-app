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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)

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
        spinner.startAnimating()
        refreshData()
    }

    @objc private func refreshControlAction() {
        refreshData()
    }

    private func refreshData() {
        Task {
            await LocationListService.shared.refresh()
            switch LocationListService.shared.mode {
            case .success:
                tableView.reloadData()
            case let .error(message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            default:
                break
            }
            spinner.stopAnimating()
            tableView.refreshControl?.endRefreshing()
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
