//
//  UsersViewController.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//

import UIKit

final class UsersViewController: UITableViewController {
    @IBOutlet weak private var searchBar: UISearchBar!
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
}

extension UsersViewController: UsersDelegate {
    func reloadUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
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
