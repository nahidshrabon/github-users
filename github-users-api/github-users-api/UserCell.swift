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
    
    static let reuseIdentifier = String(describing: UserCell.self)
    
    func configure() {
        avatar.layer.cornerRadius = 10
        avatar.image = UIImage(named: "default_avatar")
        
        username.text = "nahidshrabon"
    }
}
