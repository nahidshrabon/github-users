//
//  ProfileViewModelTests.swift
//  github-users-apiTests
//
//  Created by Md. Nahidul Islam on 30/1/23.
//

import XCTest
@testable import github_users_api

final class ProfileViewModelTests: XCTestCase {
    private var viewModelUnderTest: ProfileViewModel!
    private let dataset = ProfileViewModelMockDataset()
    
    override func tearDown() {
        viewModelUnderTest = nil
        super.tearDown()
    }
    
    func testPrepareProfile() async {
        viewModelUnderTest = .init(
            user: dataset.user,
            downloadService: ProfileMockDownloadService()
        )
        
        await viewModelUnderTest.prepareProfile()
        
        XCTAssertEqual(viewModelUnderTest.navigationTitle, dataset.login)
        XCTAssertEqual(viewModelUnderTest.name, dataset.name)
        XCTAssertEqual(viewModelUnderTest.company, dataset.company)
        XCTAssertEqual(viewModelUnderTest.location, dataset.location)
        XCTAssertEqual(viewModelUnderTest.public_repos, dataset.public_repos)
        XCTAssertEqual(viewModelUnderTest.followers, dataset.followers)
        XCTAssertEqual(viewModelUnderTest.following, dataset.following)
    }
    
    func testPrepareProfileWithError() async {
        viewModelUnderTest = .init(
            user: dataset.user,
            downloadService: ProfileMockDownloadService(testError: .networkError)
        )
        
        await viewModelUnderTest.prepareProfile()
        
        XCTAssertEqual(viewModelUnderTest.navigationTitle, dataset.login)
        XCTAssertNil(viewModelUnderTest.name)
        XCTAssertNil(viewModelUnderTest.company)
        XCTAssertNil(viewModelUnderTest.location)
        XCTAssertNil(viewModelUnderTest.public_repos)
        XCTAssertNil(viewModelUnderTest.followers)
        XCTAssertNil(viewModelUnderTest.following)
    }
}

final class ProfileMockDownloadService: ProfileDownloadService {
    var testError: ServiceError?
    var dataset: ProfileViewModelMockDataset
    
    init(testError: ServiceError? = nil) {
        self.testError = testError
        dataset = ProfileViewModelMockDataset()
    }
    
    func downloadProfile(username: String) async -> Result<Profile?, ServiceError> {
        guard let testError else { return .success(dataset.profile) }
        return .failure(testError)
    }
    
    func downloadImage(for rawURL: String, completion: @escaping (String, UIImage) -> Void) {
        completion(rawURL, UIImage())
    }
}

struct ProfileViewModelMockDataset {
    let login = "login1"
    let avatar_url = "https://test.test.test/test1"
    let name = "name1"
    let company = "company1"
    let location = "location1"
    let public_repos = 12
    let followers = 123
    let following = 456
    
    var user: User {
        User(
            login: login,
            avatar_url: avatar_url
        )
    }
    
    var profile: Profile {
        Profile(
            name: name,
            company: company,
            location: location,
            public_repos: public_repos,
            followers: followers,
            following: following
        )
    }
}
