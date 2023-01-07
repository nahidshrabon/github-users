//
//  UserModel.swift
//  github-users-api
//
//  Created by Md. Nahidul Islam on 7/1/23.
//

struct User: Decodable {
    let login: String?
    let avatar_url: String?
}
