//
//  LocationListViewController.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import OSLog
import UIKit

class LocationListViewController: UIViewController {
    static let cellIdentifier = "LocationListTableViewCell"
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .search, primaryAction: UIAction { _ in
            let navigationController = UINavigationController(rootViewController: NewLocationViewController())
            self.present(navigationController, animated: true)
        })
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
