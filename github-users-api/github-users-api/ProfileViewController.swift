//
//  ProfileViewController.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 10/1/23.
//

import UIKit

final class ProfileViewController: UIViewController {
    static func makeViewController(for user: User) -> UIViewController {
        let viewController = ProfileViewController()
        viewController.viewModel = ProfileViewModel(user: user, downloadService: APIService.shared)
        return viewController
    }
    
    private var viewModel: ProfileViewModel?
    
    lazy var profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
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
        navigationItem.title = viewModel?.navigationTitle
        
        setupInitialViews()
        
        viewModel?.delegate = self
        viewModel?.prepareProfile()
    }
    
    private func setupInitialViews() {
        setupProfileImageView()
        setupProfileInfoView()
    }
    
    private func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        profileImageView.image = UIImage(named: "default_avatar")
    }
    
    private func setupProfileInfoView() {
        view.addSubview(profileInfoStackView)
        profileInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileInfoStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            profileInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ProfileViewController: ProfileDelegate {
    func reloadProfileImage(with image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView.image = image
        }
    }
    
    func reloadProfileInfo() {
        print("profile reloaded")
    }
}
