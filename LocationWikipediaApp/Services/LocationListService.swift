//
//  LocationListService.swift
//  LocationWikipediaApp
//
//  Created by Bart van Kuik on 08/03/2023.
//

import Foundation
import OSLog

class LocationListService {
    enum Mode {
        case loading, success(LocationList), error(String)
    }

    static let shared = LocationListService()
    var mode = Mode.success(LocationList.empty)

    func refresh() async {
        do {
            mode = .loading
            let locationList = try await request()
            mode = .success(locationList)
        } catch let ServiceError.failed(message) {
            self.mode = .error(message)
        } catch {
            mode = .error(error.localizedDescription)
        }
    }

    private func request() async throws -> LocationList {
        guard let url = URL(string: Constants.locationURLString) else {
            fatalError("Project configured incorrectly")
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.failed(message: "URL response is not HTTPURLResponse")
        }
        os_log("Server statusCode: %d", log: .default, type: .debug, httpResponse.statusCode)

        if httpResponse.statusCode != 200 {
            os_log("Unexpected server statusCode: %d", log: .default, type: .error, httpResponse.statusCode)
            if let responseString = String(data: data, encoding: .utf8) {
                os_log("Response:\n%@", log: .default, type: .debug, responseString)
            }
            throw ServiceError.failed(message: "Unexpected httpCode: \(httpResponse.statusCode)")
        }

        let list = try JSONDecoder().decode(LocationList.self, from: data)
        return list
    }

    private init() {}
}
