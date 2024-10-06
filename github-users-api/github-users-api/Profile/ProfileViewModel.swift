//
//  ProfileViewModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 11/1/23.
//

import UIKit

protocol ProfileDownloadService {
    func downloadProfile(username: String) async -> Result<Profile?, ServiceError>
    func downloadImage(for rawURL: String, completion: @escaping (String, UIImage) -> Void)
}

protocol ProfileDelegate {
    func reloadProfileImage(with: UIImage?)
    func reloadProfileInfo()
    func showError(for: ServiceError)
}

final class ProfileViewModel {
    private let user: User
    private let downloadService: ProfileDownloadService
    
    private var profile: Profile?
    var delegate: ProfileDelegate?
    
    init(user: User, downloadService: ProfileDownloadService) {
        self.user = user
        self.downloadService = downloadService
    }
}

extension ProfileViewModel {
    var navigationTitle: String? { user.login }
    
    var name: String? { profile?.name }
    
    var company: String? { profile?.company }
    
    var location: String? { profile?.location }
    
    var followers: Int? { profile?.followers }
    
    var following: Int? { profile?.following }
    
    var public_repos: Int? { profile?.public_repos }
    
    func prepareProfile() async {
        if let avatarURL = user.avatar_url {
            downloadService.downloadImage(for: avatarURL) { [weak self] responseURL, image in
                self?.delegate?.reloadProfileImage(with: image)
            }
        }
        
        if let username = user.login {
            let result = await downloadService.downloadProfile(username: username)
            switch result {
            case .success(let profile):
                self.profile = profile
                self.delegate?.reloadProfileInfo()
            case .failure(let error):
                self.delegate?.showError(for: error)
            }
        }
    }
}
