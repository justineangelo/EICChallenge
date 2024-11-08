//
//  models.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/5/24.
//

import Foundation

struct ActivityResponse: Decodable {
    let id: String
    let state: String
    let stateChangedAt: Date?
    let title: String?
    let description: String
    let duration: String
    let activity: Activity
}

struct Activity: Decodable {
    let screens: [Screen]
    
    enum ScreenType: String, Decodable {
        case multipleChoice = "multipleChoiceModuleScreen"
        case recap = "recapModuleScreen"
        case unknown
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            self = ScreenType(rawValue: string) ?? .unknown
        }
    }
    
    struct Screen: Decodable {
        let id: String
        let type: ScreenType
        let question: String?
        let multipleChoicesAllowed: Bool?
        let choices: [Item]?
        let eyebrow: String?
        let body: String?
        let answers: [Item]?
        let correctAnswer: String?
        
        struct Item: Decodable {
            let id: String
            let text: String?
            let emoji: String?
        }
    }
}

