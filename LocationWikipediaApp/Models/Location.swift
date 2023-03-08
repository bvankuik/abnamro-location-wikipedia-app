//
//  LocationModel.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import Foundation

struct Location: Decodable {
    let name: String?
    let lat: Double
    let long: Double
}
