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
        viewModel?.numberOfRows ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath)
                as? UserCell
        else { return UITableViewCell() }
        
        let cellData = viewModel?.cellData(for: indexPath.row)
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
    
}
