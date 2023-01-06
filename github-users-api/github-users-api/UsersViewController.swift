//
//  UsersViewController.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//

import UIKit

class UsersViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Users"
    }
}

extension UsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath)
                as? UserCell
        else { return UITableViewCell() }

        cell.configure()

        return cell
    }
}
