//
//  AnimalPhoto.swift
//  AnimalGallery
//
//  Created by Uriel Ortega on 29/04/25.
//

struct AnimalPhoto: Identifiable {
    let id: String
    let description: String
    let altDescription: String
    let regularImageURL: String
    let smallImageURL: String
    let topics: [Topic]
    let user: User
}

struct Topic: Decodable {
    let status: String
}

struct User: Identifiable, Decodable {
    let id: String
    let username: String
    let name: String
}

extension AnimalPhoto: Decodable {
    /// Enums used to map the JSON keys to the properties of the AnimalPhoto struct during decoding:
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case altDescription = "alt_description"
        case urls
        case topicSubmissions = "topic_submissions"
        case user
    }
    
    private enum URLKeys: String, CodingKey {
        case regular
        case small
    }
    
    /// Custom initializer with data validation that tells the AnimalPhoto struct how to decode itself from a JSON object.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        altDescription = try container.decode(String.self, forKey: .altDescription)
        
        let urlsContainer = try container.nestedContainer(keyedBy: URLKeys.self, forKey: .urls)
        regularImageURL = try urlsContainer.decode(String.self, forKey: .regular)
        smallImageURL = try urlsContainer.decode(String.self, forKey: .small)
        
        let topicsDict = try container.decode([String : Topic].self, forKey: .topicSubmissions)
        topics = topicsDict.map { $0.value } // Populate Array with Dictionary.
        
        user = try container.decode(User.self, forKey: .user)
    }
}
