//
//  UsersViewController.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//

import UIKit

final class UsersViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    private var viewModel: UsersViewModel?
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        viewModel = UsersViewModel(
            downloadService: APIService.shared,
            delegate: self
        )
        
        loadingView.startAnimating()
        viewModel?.prepareUsers()
    }
}

extension UsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching
        ? (viewModel?.numberOfSearchResultRows ?? 0)
        : (viewModel?.numberOfRows ?? 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath)
                as? UserCell
        else { return UITableViewCell() }
        
        let cellData = isSearching
        ? viewModel?.cellDataSearchResult(for: indexPath.row)
        : viewModel?.cellData(for: indexPath.row)
        
        cell.configure(with: cellData)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = isSearching
        ? viewModel?.cellDataSearchResult(for: indexPath.row)
        : viewModel?.cellData(for: indexPath.row)
        
        guard let user = cellData else { return }
        
        let nextViewController = ProfileViewController.makeViewController(for: user)
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension UsersViewController: UsersDelegate {
    func reloadUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.loadingView.stopAnimating()
        }
    }
    
    func showError(for error: ServiceError) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorAlert(for: error)
        }
    }
    
    private func showErrorAlert(for error: ServiceError) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(
            .init(
                title: "Cancel",
                style: .cancel,
                handler: { [weak self] _ in
                    self?.loadingView.stopAnimating()
                }
            )
        )
        
        alert.addAction(
            .init(
                title: "Retry",
                style: .default,
                handler: { [weak self] _ in
                    self?.viewModel?.prepareUsers()
                }
            )
        )
        
        switch error {
        case .networkError:
            alert.title = "No Network Connection!"
            
        case .serverError:
            alert.title = "Server Error!"
        }
        
        present(alert, animated: true)
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.makeSearchResult(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
}
