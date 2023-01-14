//
//  ProfileViewModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 11/1/23.
//

import UIKit

protocol ProfileDownloadService {
    func downloadProfile(username: String, completion: @escaping (Profile?, ServiceError?) -> Void)
}

protocol ProfileDelegate {
    func reloadProfileImage(with: UIImage?)
    func reloadProfileInfo()
}

final class ProfileViewModel {
    private var user: User
    private var downloadService: APIService
    
    private var profile: Profile?
    
    var delegate: ProfileDelegate?
    
    init(user: User, downloadService: APIService) {
        self.user = user
        self.downloadService = downloadService
    }
}

extension ProfileViewModel {
    var navigationTitle: String? { user.login }
    
    func prepareProfile() {
        if let avatarURL = user.avatar_url {
            downloadService.downloadImage(for: avatarURL) { [weak self] responseURL, image in
                self?.delegate?.reloadProfileImage(with: image)
            }
        }
        
        if let username = user.login {
            downloadService.downloadProfile(username: username) { [weak self] profile, error in
                if let error {
                    print(error)
                    return
                }
                
                self?.profile = profile
                self?.delegate?.reloadProfileInfo()
            }
        }
    }
}
