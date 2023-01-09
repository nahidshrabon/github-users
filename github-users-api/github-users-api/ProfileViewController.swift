//
//  ProfileViewController.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 10/1/23.
//

import UIKit

final class ProfileViewController: UIViewController {
    static func makeViewController() -> UIViewController {
        return ProfileViewController()
    }
    
    lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var profileInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "username"
        
        setupViews()
    }
    
    private func setupViews() {
        setupProfileImageView()
        setupProfileInfoView()
    }
    
    private func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        profileImageView.image = UIImage(named: "default_avatar")
    }
    
    private func setupProfileInfoView() {
        
    }
}
