//
//  UsersViewModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//


protocol UsersDownloadService {
    func downloadUsers(completion: @escaping ([User], ServiceError?) -> Void)
}

protocol UsersDelegate {
    func reloadUsers()
}

final class UsersViewModel {
    private var users: [User]
    private var filteredUsers: [User]
    private var downloadService: UsersDownloadService
    private var delegate: UsersDelegate
    
    init(downloadService: UsersDownloadService, delegate: UsersDelegate) {
        users = []
        filteredUsers = []
        
        self.downloadService = downloadService
        self.delegate = delegate
        
        fetchUsersData()
    }
    
    private func fetchUsersData() {
        downloadService.downloadUsers { [weak self] users, error in
            guard let error else {
                self?.users = users
                self?.delegate.reloadUsers()
                return
            }
            
            print(error)
        }
    }
}

extension UsersViewModel {
    var numberOfRows: Int { users.count }
    
    var numberOfSearchResultRows: Int { filteredUsers.count }
    
    func cellData(for index: Int) -> User { users[index] }
    
    func cellDataSearchResult(for index: Int) -> User { filteredUsers[index] }
    
    func makeSearchResult(for text: String) {
        filteredUsers = users.filter { $0.login?.hasPrefix(text.lowercased()) ?? false}
        delegate.reloadUsers()
    }
}
