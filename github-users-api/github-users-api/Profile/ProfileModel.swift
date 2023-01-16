//
//  ProfileModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 11/1/23.
//

struct Profile: Decodable {
    let name: String?
    let company: String?
    let location: String?
    let public_repos: Int?
    let followers: Int?
    let following: Int?
}
