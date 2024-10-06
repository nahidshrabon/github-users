//
//  APIService.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 8/1/23.
//

import Foundation
import UIKit

enum ServiceError: Error {
    case invalidURL
    case networkError
    case serverError
}

enum DownloadURL {
    case usersURL
    case profieURL(String)
    
    private var rootURLString: String { "https://api.github.com/users" }
    
    var url: URL? {
        switch self {
        case .usersURL:
            return URL(string: rootURLString)
        case .profieURL(let username):
            return URL(string: "\(rootURLString)/\(username)")
        }
    }
}

final class APIService: UsersDownloadService, ProfileDownloadService {
    static let shared = APIService()
    
    var imageCache: [String: UIImage] = [:]
    
    lazy var urlSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.waitsForConnectivity = true
        sessionConfiguration.timeoutIntervalForResource = 10
        return URLSession(configuration: sessionConfiguration)
    }()
    
    func downloadUsers() async throws -> [User] {
        guard let url = DownloadURL.usersURL.url else { throw ServiceError.invalidURL }
        let (data, _) = try await urlSession.data(for: .init(url: url))
        
        guard
            let decodedUserList = try? JSONDecoder().decode([User].self, from: data)
        else { throw ServiceError.serverError }
        
        print("Users data downloaded!")
        return decodedUserList
    }
    
    func downloadProfile(username: String) async -> Result<Profile?, ServiceError> {
        await withCheckedContinuation { continuation in
            downloadProfile(username: username) { profile, error in
                if let error {
                    continuation.resume(returning: .failure(error))
                } else {
                    continuation.resume(returning: .success(profile))
                }
            }
        }
    }
    
    private func downloadProfile(username: String, completion: @escaping (Profile?, ServiceError?) -> Void) {
        guard let url = DownloadURL.profieURL(username).url else { return }
        
        let urlRequest = URLRequest(url: url)
        
        urlSession.dataTask(with: urlRequest) { data, _, error in
            guard let data else {
                completion(nil, .networkError)
                return
            }
            
            guard
                let decodedProfile = try? JSONDecoder().decode(Profile.self, from: data)
            else {
                completion(nil, .serverError)
                return
            }
            
            print("Profile data downloaded!")
            completion(decodedProfile, nil)
        }.resume()
    }
    
    func downloadImage(for rawURL: String, completion: @escaping (String, UIImage) -> Void) {
        if let image = imageCache[rawURL] {
            completion(rawURL, image)
            return
        }
        
        guard let url = URL(string: rawURL) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard
                let data,
                let image = UIImage(data: data)
            else { return }
            
            self?.imageCache[url.absoluteString] = image
            
            completion(url.absoluteString, image)
        }.resume()
    }
}
