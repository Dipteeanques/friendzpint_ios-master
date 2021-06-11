//
//  FollowersResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 05/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - FollowersResponsModel
public struct FollowersResponsModel: Codable {
    public let success: Bool
    public let data: DataClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataClass: Codable {
    public let currentPage: Int
    public let data: [DatumFollower]
    public let from: Int
    public let lastPage: Int
    public let nextPageURL: String
    public let path: String
    public let perPage: Int
    public let prevPageURL: String
    public let to: Int
    public let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case from = "from"
        case lastPage = "last_page"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }

    public init(currentPage: Int, data: [DatumFollower], from: Int, lastPage: Int, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
        self.currentPage = currentPage
        self.data = data
        self.from = from
        self.lastPage = lastPage
        self.nextPageURL = nextPageURL
        self.path = path
        self.perPage = perPage
        self.prevPageURL = prevPageURL
        self.to = to
        self.total = total
    }
}

// MARK: - Datum
public struct DatumFollower: Codable {
    public let id: Int
    public let timelineID: Int
    public let verified: Int
    public let name: String
    public let avatar: String
    public let username: String
    public var isFollow: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timelineID = "timeline_id"
        case verified = "verified"
        case name = "name"
        case avatar = "avatar"
        case username = "username"
        case isFollow = "is_follow"
    }

    public init(id: Int, timelineID: Int, verified: Int, name: String, avatar: String, username: String, isFollow: Int) {
        self.id = id
        self.timelineID = timelineID
        self.verified = verified
        self.name = name
        self.avatar = avatar
        self.username = username
        self.isFollow = isFollow
    }
}
