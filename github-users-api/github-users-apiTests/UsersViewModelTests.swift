//
//  UsersViewModelTests.swift
//  github-users-apiTests
//
//  Created by Md. Nahidul Islam on 17/1/23.
//

import XCTest
@testable import github_users_api

final class UsersViewModelTests: XCTestCase {
    private var viewModelUnderTest: UsersViewModel!
    private let dataset = UsersViewModelMockDataset()
    
    override func tearDown() {
        viewModelUnderTest = nil
        super.tearDown()
    }
    
    func testPrepareUsers() async {
        viewModelUnderTest = UsersViewModel(
            downloadService: UsersMockDownloadService(),
            delegate: UsersMockDelegate()
        )
        
        await viewModelUnderTest.prepareUsers()
        
        XCTAssertEqual(viewModelUnderTest.numberOfRows, dataset.users.count)
        XCTAssertEqual(viewModelUnderTest.cellData(for: 0), dataset.user1)
        XCTAssertEqual(viewModelUnderTest.cellData(for: 1), dataset.user2)
    }
    
    func testPrepareUsersWithError() async {
        viewModelUnderTest = UsersViewModel(
            downloadService: UsersMockDownloadService(testError: .networkError),
            delegate: UsersMockDelegate()
        )
        
        await viewModelUnderTest.prepareUsers()
        
        XCTAssertEqual(viewModelUnderTest.numberOfRows, 0)
    }
    
    func testMakeSearchResult() async {
        viewModelUnderTest = UsersViewModel(
            downloadService: UsersMockDownloadService(),
            delegate: UsersMockDelegate()
        )
        
        await viewModelUnderTest.prepareUsers()
        viewModelUnderTest.makeSearchResult(for: "login2")
        
        XCTAssertEqual(viewModelUnderTest.numberOfSearchResultRows, 1)
        XCTAssertEqual(viewModelUnderTest.cellDataSearchResult(for: 0), dataset.user2)
    }
    
    func testmMakeSearchResultForUnknownUser() async {
        viewModelUnderTest = UsersViewModel(
            downloadService: UsersMockDownloadService(),
            delegate: UsersMockDelegate()
        )
        
        await viewModelUnderTest.prepareUsers()
        viewModelUnderTest.makeSearchResult(for: "unknown")
        
        XCTAssertEqual(viewModelUnderTest.numberOfSearchResultRows, 0)
    }
}

final class UsersMockDownloadService: UsersDownloadService {
    var testError: ServiceError?
    var dataset: UsersViewModelMockDataset
    
    init(testError: ServiceError? = nil) {
        self.testError = testError
        dataset = UsersViewModelMockDataset()
    }
    
    func downloadUsers() async throws -> [User] {
        guard let testError else { return dataset.users }
        throw testError
    }
}

final class UsersMockDelegate: UsersDelegate {
    func reloadUsers() {}
    func showError(for: ServiceError) {}
}

struct UsersViewModelMockDataset {
    let user1 = User(
        login: "login1",
        avatar_url: "https://test.test.test/test1"
    )
    
    let user2 = User(
        login: "login2",
        avatar_url: "https://test.test.test/test2"
    )
    
    var users: [User] { [user1, user2] }
}
