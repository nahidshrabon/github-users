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
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        imageView.image = UIImage(named: "default_avatar")
        return imageView
    }()
    
    private lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        return stackView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel?.navigationTitle
        viewModel?.delegate = self
        
        prepareData()
    }
    
    private func prepareData() {
        loadingView.startAnimating()
        Task { await viewModel?.prepareProfile() }
    }
}

extension ProfileViewController: ProfileDelegate {
    func reloadProfileImage(with image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView.image = image
        }
    }
    
    func reloadProfileInfo() {
        DispatchQueue.main.async { [weak self] in
            self?.setupName()
            self?.setupCompany()
            self?.setupLocation()
            self?.setupFollow()
            self?.setupRepos()
            self?.loadingView.stopAnimating()
        }
    }
    
    func showError(for error: ServiceError) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.showErrorAlert(for: error)
        }
    }
}

private extension ProfileViewController {
    func setupName() {
        guard let name = viewModel?.name else { return }
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 24, weight: .light)
        nameLabel.text = name
        
        profileInfoStackView.addArrangedSubview(nameLabel)
    }
    
    func setupCompany() {
        guard let company = viewModel?.company else { return }
        
        let companyStackView = UIStackView()
        companyStackView.axis = .horizontal
        companyStackView.alignment = .center
        companyStackView.spacing = 5
        
        let companyIconImageView = UIImageView(image: .init(named: "company_icon"))
        companyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        companyIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        companyIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        companyStackView.addArrangedSubview(companyIconImageView)
        
        let companyLabel = UILabel()
        companyLabel.numberOfLines = 0
        companyLabel.text = company
        companyStackView.addArrangedSubview(companyLabel)
        
        profileInfoStackView.addArrangedSubview(companyStackView)
    }
    
    func setupLocation() {
        guard let location = viewModel?.location else { return }
        
        let locationStackView = UIStackView()
        locationStackView.axis = .horizontal
        locationStackView.spacing = 5
        
        let locationIconImageView = UIImageView(image: .init(named: "location_icon"))
        locationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        locationIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        locationIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationStackView.addArrangedSubview(locationIconImageView)
        
        let locationLabel = UILabel()
        locationLabel.text = location
        locationStackView.addArrangedSubview(locationLabel)
        
        profileInfoStackView.addArrangedSubview(locationStackView)
    }
    
    func setupFollow() {
        guard
            let followers = viewModel?.followers,
            let following = viewModel?.following
        else { return }
        
        let followStackView = UIStackView()
        followStackView.axis = .horizontal
        followStackView.spacing = 5
        
        let followIconImageView = UIImageView(image: .init(named: "follow_icon"))
        followIconImageView.translatesAutoresizingMaskIntoConstraints = false
        followIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        followIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        followStackView.addArrangedSubview(followIconImageView)
        
        let followersLabel = UILabel()
        followersLabel.text = "\(followers) followers"
        followStackView.addArrangedSubview(followersLabel)
        
        let followingLabel = UILabel()
        followingLabel.text = ": \(following) following"
        followStackView.addArrangedSubview(followingLabel)
        
        profileInfoStackView.addArrangedSubview(followStackView)
    }
    
    func setupRepos() {
        guard let repos = viewModel?.public_repos else { return }
        
        let reposStackView = UIStackView()
        reposStackView.axis = .horizontal
        reposStackView.alignment = .center
        reposStackView.spacing = 5
        
        let reposIconImageView = UIImageView(image: .init(named: "repos_icon"))
        reposIconImageView.translatesAutoresizingMaskIntoConstraints = false
        reposIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        reposIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reposStackView.addArrangedSubview(reposIconImageView)
        
        let reposLabel = UILabel()
        reposLabel.numberOfLines = 0
        reposLabel.text = "\(repos) repositories"
        reposStackView.addArrangedSubview(reposLabel)
        
        profileInfoStackView.addArrangedSubview(reposStackView)
    }
    
    func showErrorAlert(for error: ServiceError) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(
            .init(
                title: "Cancel",
                style: .cancel
            )
        )
        
        alert.addAction(
            .init(
                title: "Retry",
                style: .default,
                handler: { [weak self] _ in self?.prepareData() }
            )
        )
        
        switch error {
        case .invalidURL:
            alert.message = "Invalid URL!"
            
        case .networkError:
            alert.title = "No Network Connection!"
            
        case .serverError:
            alert.title = "Server Error!"
        }
        
        present(alert, animated: true)
    }
}
