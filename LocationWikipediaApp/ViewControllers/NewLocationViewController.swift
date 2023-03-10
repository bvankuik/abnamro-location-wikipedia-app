//
//  NewLocationViewController.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 10/03/2023.
//

import CoreLocation
import OSLog
import UIKit

class NewLocationViewController: UIViewController {
    private let latitudeTextField = UITextField()
    private let longitudeTextField = UITextField()
    private let submitButton = UIButton(configuration: .gray())
    private var viewModel = NewLocationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16

        submitButton.configuration?.title = "Go to location"
        submitButton.configuration?.image = UIImage(systemName: "location.magnifyingglass")
        submitButton.addAction(UIAction(handler: submitButtonHandler(_:)), for: .touchUpInside)

        latitudeTextField.placeholder = "Latitude as decimal number"
        latitudeTextField.addAction(UIAction { _ in
            self.viewModel.latitudeString = self.latitudeTextField.text ?? ""
            self.refreshView()
        }, for: .editingChanged)

        longitudeTextField.placeholder = "Longitude as decimal number"
        longitudeTextField.addAction(UIAction { _ in
            self.viewModel.longitudeString = self.longitudeTextField.text ?? ""
            self.refreshView()
        }, for: .editingChanged)

        for textField in [latitudeTextField, longitudeTextField] {
            textField.borderStyle = .roundedRect
            textField.keyboardType = .decimalPad
        }

        stackView.addArrangedSubview(latitudeTextField)
        stackView.addArrangedSubview(longitudeTextField)
        stackView.addArrangedSubview(submitButton)

        view.addSubview(stackView)
        let constraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        view.addConstraints(constraints)
        view.backgroundColor = UIColor.systemBackground
        title = "Add location"
        refreshView()
    }

    private func submitButtonHandler(_: UIAction) {
        dismiss(animated: true) {
            self.viewModel.location.open()
        }
    }

    private func refreshView() {
        submitButton.isEnabled = CLLocationCoordinate2DIsValid(viewModel.coordinate)
    }
}
