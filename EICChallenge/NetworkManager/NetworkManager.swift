//
//  NetworkManager.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/5/24.
//

import Foundation

enum APIError: Error {
    case invalidURL(String)
    case networkError(Error)
    case responseError(statusCode: Int)
    case unknownError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: \(urlString)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .responseError(let statusCode):
            return "Received status code: \(statusCode)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://file.notion.so/f/f/e430ac3e-ca7a-48f9-804c-8fe9f7d4a267/174c6c45-c116-4762-8550-607cddb04270/activity-response-ios.json?table=block&id=111284a8-e7d3-80ea-a701-fad40b7b30ca&spaceId=e430ac3e-ca7a-48f9-804c-8fe9f7d4a267&expirationTimestamp=1731038400000&signature=8rNN2U8ncTN6Ngu9sL0aPlBNXpa4hCXUS2XqVPvk2Qs&downloadName="
    private let getActivity = "activity-response-ios.json"
    private let jsonDecoder = JSONDecoder()
    
    func get<T: Decodable>(_ urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL(urlString)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                throw APIError.responseError(statusCode: response.statusCode)
            }
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
}


protocol ActivityService {
    func getInitialActivity() async throws -> ActivityResponse
}

extension NetworkManager: ActivityService {
    func getInitialActivity() async throws -> ActivityResponse {
//        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        return try await get(baseURL + getActivity)
    }
}
