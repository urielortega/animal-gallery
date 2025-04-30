//
//  Secrets.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

import Foundation

final class Secrets {
    static var unsplashAPIKey: String {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict["UNSPLASH_API_KEY"] as? String
        else {
            fatalError("API Key not found. Make sure you added it to Secrets.plist")
        }
        return key
    }
}
