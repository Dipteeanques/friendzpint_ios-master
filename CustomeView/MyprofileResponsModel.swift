//
//  MyprofileResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 14/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - MyprofileResponsModel
public struct MyprofileResponsModel: Codable {
    public let success: Bool
    public let data: DataMyprofile
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataMyprofile, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataMyprofile: Codable {
    public let id: Int
    public let followers: Int
    public let following: Int
    public let sendRequested: String
    public let messagePrivacy: String
    public let checkUser: String
    public let username: String
    public let name: String
    public let about: String
    public let birthday: String
    public let type: String
    public let city: String
    public let country: String
    public let hobbies: String
    public let interests: String
    public let gender: String
    public let designation: String
    public let facebookLink: String
    public let twitterLink: String
    public let dribbbleLink: String
    public let instagramLink: String
    public let youtubeLink: String
    public let linkedinLink: String
    public let avatar: String
    public let cover: String
    public let timelineAd: [TimelineAd]
    public let notificationCounter: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case followers = "followers"
        case following = "following"
        case sendRequested = "send_requested"
        case messagePrivacy = "message_privacy"
        case checkUser = "check_user"
        case username = "username"
        case name = "name"
        case about = "about"
        case birthday = "birthday"
        case type = "type"
        case city = "city"
        case country = "country"
        case hobbies = "hobbies"
        case interests = "interests"
        case gender = "gender"
        case designation = "designation"
        case facebookLink = "facebook_link"
        case twitterLink = "twitter_link"
        case dribbbleLink = "dribbble_link"
        case instagramLink = "instagram_link"
        case youtubeLink = "youtube_link"
        case linkedinLink = "linkedin_link"
        case avatar = "avatar"
        case cover = "cover"
        case timelineAd = "timeline_ad"
        case notificationCounter = "notification_counter"
    }

    public init(id: Int, followers: Int, following: Int, sendRequested: String, messagePrivacy: String, checkUser: String, username: String, name: String, about: String, birthday: String, type: String, city: String, country: String, hobbies: String, interests: String, gender: String, designation: String, facebookLink: String, twitterLink: String, dribbbleLink: String, instagramLink: String, youtubeLink: String, linkedinLink: String, avatar: String, cover: String, timelineAd: [TimelineAd], notificationCounter: Int) {
        self.id = id
        self.followers = followers
        self.following = following
        self.sendRequested = sendRequested
        self.messagePrivacy = messagePrivacy
        self.checkUser = checkUser
        self.username = username
        self.name = name
        self.about = about
        self.birthday = birthday
        self.type = type
        self.city = city
        self.country = country
        self.hobbies = hobbies
        self.interests = interests
        self.gender = gender
        self.designation = designation
        self.facebookLink = facebookLink
        self.twitterLink = twitterLink
        self.dribbbleLink = dribbbleLink
        self.instagramLink = instagramLink
        self.youtubeLink = youtubeLink
        self.linkedinLink = linkedinLink
        self.avatar = avatar
        self.cover = cover
        self.timelineAd = timelineAd
        self.notificationCounter = notificationCounter
    }
}

// MARK: - TimelineAd
public struct TimelineAd: Codable {
    public let id: Int
    public let timelineAdDescription: String
    public let timelineID: Int
    public let userID: Int
    public let active: Int
    public let soundcloudTitle: String
    public let soundcloudID: Int
    public let youtubeTitle: String
    public let youtubeVideoID: String
    public let location: String
    public let type: String
    public let sharedPostID: Int
    public let usersLikedCount: Int
    public let commentsCount: Int
    public let isLiked: Int
    public let isDisliked: Int
    public let isHide: Int
    public let isReport: Int
    public let isSaved: Int
    public let isNotification: Int
    public let isUsersShared: Int
    public let userPage: [JSONAny]
    public let userGroup: [JSONAny]
    public let usersAvatar: String
    public let usersName: String
    public let username: String
    public let isMyPost: Int
    public let usersType: String
    public let images: [JSONAny]
    public let usersLiked: [JSONAny]
    public let usersDislikedCount: Int
    public let usersDisliked: [JSONAny]
    public let usersTagged: [JSONAny]
    public let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timelineAdDescription = "description"
        case timelineID = "timeline_id"
        case userID = "user_id"
        case active = "active"
        case soundcloudTitle = "soundcloud_title"
        case soundcloudID = "soundcloud_id"
        case youtubeTitle = "youtube_title"
        case youtubeVideoID = "youtube_video_id"
        case location = "location"
        case type = "type"
        case sharedPostID = "shared_post_id"
        case usersLikedCount = "users_liked_count"
        case commentsCount = "comments_count"
        case isLiked = "is_liked"
        case isDisliked = "is_disliked"
        case isHide = "is_hide"
        case isReport = "is_report"
        case isSaved = "is_saved"
        case isNotification = "is_notification"
        case isUsersShared = "is_users_shared"
        case userPage = "user_page"
        case userGroup = "user_group"
        case usersAvatar = "users_avatar"
        case usersName = "users_name"
        case username = "username"
        case isMyPost = "is_my_post"
        case usersType = "users_type"
        case images = "images"
        case usersLiked = "users_liked"
        case usersDislikedCount = "users_disliked_count"
        case usersDisliked = "users_disliked"
        case usersTagged = "users_tagged"
        case createdAt = "created_at"
    }

    public init(id: Int, timelineAdDescription: String, timelineID: Int, userID: Int, active: Int, soundcloudTitle: String, soundcloudID: Int, youtubeTitle: String, youtubeVideoID: String, location: String, type: String, sharedPostID: Int, usersLikedCount: Int, commentsCount: Int, isLiked: Int, isDisliked: Int, isHide: Int, isReport: Int, isSaved: Int, isNotification: Int, isUsersShared: Int, userPage: [JSONAny], userGroup: [JSONAny], usersAvatar: String, usersName: String, username: String, isMyPost: Int, usersType: String, images: [JSONAny], usersLiked: [JSONAny], usersDislikedCount: Int, usersDisliked: [JSONAny], usersTagged: [JSONAny], createdAt: String) {
        self.id = id
        self.timelineAdDescription = timelineAdDescription
        self.timelineID = timelineID
        self.userID = userID
        self.active = active
        self.soundcloudTitle = soundcloudTitle
        self.soundcloudID = soundcloudID
        self.youtubeTitle = youtubeTitle
        self.youtubeVideoID = youtubeVideoID
        self.location = location
        self.type = type
        self.sharedPostID = sharedPostID
        self.usersLikedCount = usersLikedCount
        self.commentsCount = commentsCount
        self.isLiked = isLiked
        self.isDisliked = isDisliked
        self.isHide = isHide
        self.isReport = isReport
        self.isSaved = isSaved
        self.isNotification = isNotification
        self.isUsersShared = isUsersShared
        self.userPage = userPage
        self.userGroup = userGroup
        self.usersAvatar = usersAvatar
        self.usersName = usersName
        self.username = username
        self.isMyPost = isMyPost
        self.usersType = usersType
        self.images = images
        self.usersLiked = usersLiked
        self.usersDislikedCount = usersDislikedCount
        self.usersDisliked = usersDisliked
        self.usersTagged = usersTagged
        self.createdAt = createdAt
    }
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

public class JSONAny: Codable {

    public let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
