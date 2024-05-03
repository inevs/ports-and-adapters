//
//  main.swift
//  PortsAdapter
//
//  Created by Sven Günther on 03.05.24.
//

import Foundation

if let url = URL(string: "https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations.json") {
    do {
        let data = try await loadDataFrom(url)
        let json: [Station] = try await decode(data)
        printCSV(json)
    }
    catch {
        print("error: \(error)")
    }
}

func loadDataFrom(_ url: URL) async throws -> Data {
    try Data(contentsOf: url)
}

func decode<T>(_ data: Data) async throws -> T where T: Decodable {
    try JSONDecoder().decode(T.self, from: data)
}

func printCSV(_ stations: [Station]) {
    print("uuid;number;shortname;longname;km;agency;longitude;latitude;watershortname;waterlongname")
    stations.forEach { station in
        print(station.asCSV())
    }
}

struct Station: Codable {
    let uuid: String
    let number: String
    let shortname: String
    let longname: String
    let km: Double?
    let agency: String
    let longitude: Double?
    let latitude: Double?
    let water: Water
}

struct Water: Codable {
    let shortname: String
    let longname: String
}

extension Station {
    func asCSV() -> String {
        "\(uuid);\(number);\(shortname);\(longname);\(km ?? 0);\(agency);\(longitude ?? 0);\(latitude ?? 0);\(water.longname);\(water.shortname)"
    }
}
