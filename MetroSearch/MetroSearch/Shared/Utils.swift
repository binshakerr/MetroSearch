//
//  Utils.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 26/10/2021.
//

import Foundation

class Utils {
    enum MockResponseType: String {
        case SearchFullMock = "SearchFullMock"
        case SearchEmptyMock = "SearchEmptyMock"
        case ObjectDetailsSuccessMock = "ObjectDetailsSuccessMock"
        case ObjectDetailsFailureMock = "ObjectDetailsFailureMock"
        
        var sampleData: Data? {
            return jsonDataFromFile(self.rawValue)
        }
        
        func sampleDataFor(_ testClass: AnyObject) -> Data? {
            let bundle = Bundle(for: type(of: testClass))
            return jsonDataFromFile(self.rawValue, bundle: bundle)
        }
        
        func jsonDataFromFile(_ fileName: String, bundle: Bundle = Bundle.main) -> Data? {
            guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
                print("Error: invalid file URL")
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch let error {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
