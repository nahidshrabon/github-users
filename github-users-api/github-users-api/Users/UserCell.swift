//
//  UserCell.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    private var avatarURL: String?
    
    static let reuseIdentifier = String(describing: UserCell.self)
    
    func configure(with user: User?) {
        username.text = user?.login
        
        avatar.layer.cornerRadius = 10
        avatar.image = UIImage(named: "default_avatar")
        
        avatarURL = user?.avatar_url
        guard let url = avatarURL else { return }
        
        APIService.shared.downloadImage(for: url) { [weak self] responseURL, image in
            guard
                let cellURL = self?.avatarURL,
                cellURL == responseURL
            else { return }
            
            DispatchQueue.main.async {
                self?.avatar.image = image
            }
        }
    }
}
