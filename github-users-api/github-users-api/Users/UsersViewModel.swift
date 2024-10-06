//
//  UsersViewModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//


protocol UsersDownloadService {
    func downloadUsers() async throws -> [User]
}

protocol UsersDelegate {
    func reloadUsers()
    func showError(for: ServiceError)
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
    }
    
    func prepareUsers() async {
        do {
            users = try await downloadService.downloadUsers()
            delegate.reloadUsers()
        } catch {
            guard let error = error as? ServiceError else {
                print("Unknown error: \(error)")
                delegate.showError(for: .networkError)
                return
            }
            delegate.showError(for: error)
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
