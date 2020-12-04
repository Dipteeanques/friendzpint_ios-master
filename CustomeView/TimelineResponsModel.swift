// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let timelineResponsModel = try? newJSONDecoder().decode(TimelineResponsModel.self, from: jsonData)

import Foundation

// MARK: - TimelineResponsModel
public struct TimelineResponsModel: Codable {
    public let success: Bool
    public let data: [Datum]
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: [Datum], message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - Datum
public struct Datum: Codable {
    public let id: Int
    public let datumDescription: String
    public let timelineID: Int
    public let userID: Int
    public let active: Int
    public let soundcloudTitle: String
    public let soundcloudID: Int
    public let youtubeTitle: String
    public let youtubeVideoID: String
    public let location: String
    public let type: TypeEnum
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
    public let userPage: String
    public let userGroup: UserGroupUnion
    public let usersAvatar: String
    public let usersName: UsersName
    public let username: Username
    public let isMyPost: Int
    public let usersType: UsersType
    public let images: [String?]
    public let usersLiked: [String?]
    public let isSponsored: Int
    public let usersDislikedCount: Int
    public let usersDisliked: [String?]
    public let usersTagged: [String?]
    public let createdAt: String
    public let sharedPersonName: String
    public let sharedUsername: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case datumDescription = "description"
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
        case isSponsored = "is_sponsored"
        case usersDislikedCount = "users_disliked_count"
        case usersDisliked = "users_disliked"
        case usersTagged = "users_tagged"
        case createdAt = "created_at"
        case sharedPersonName = "shared_person_name"
        case sharedUsername = "shared_username"
    }

    public init(id: Int, datumDescription: String, timelineID: Int, userID: Int, active: Int, soundcloudTitle: String, soundcloudID: Int, youtubeTitle: String, youtubeVideoID: String, location: String, type: TypeEnum, sharedPostID: Int, usersLikedCount: Int, commentsCount: Int, isLiked: Int, isDisliked: Int, isHide: Int, isReport: Int, isSaved: Int, isNotification: Int, isUsersShared: Int, userPage: String, userGroup: UserGroupUnion, usersAvatar: String, usersName: UsersName, username: Username, isMyPost: Int, usersType: UsersType, images: [String], usersLiked: [String?], isSponsored: Int, usersDislikedCount: Int, usersDisliked: [String?], usersTagged: [String?], createdAt: String, sharedPersonName: String, sharedUsername: String) {
        self.id = id
        self.datumDescription = datumDescription
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
        self.isSponsored = isSponsored
        self.usersDislikedCount = usersDislikedCount
        self.usersDisliked = usersDisliked
        self.usersTagged = usersTagged
        self.createdAt = createdAt
        self.sharedPersonName = sharedPersonName
        self.sharedUsername = sharedUsername
    }
}

public enum TypeEnum: String, Codable {
    case image = "image"
    case text = "text"
    case video = "video"
}

public enum UserGroupUnion: Codable {
    case string(String)
    case userGroupClass(UserGroupClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(UserGroupClass.self) {
            self = .userGroupClass(x)
            return
        }
        throw DecodingError.typeMismatch(UserGroupUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for UserGroupUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .userGroupClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - UserGroupClass
public struct UserGroupClass: Codable {
    public let id: Int
    public let name: String
    public let username: String
    public let type: String
    public let invitePrivacy: String
    public let memberPrivacy: String
    public let postPrivacy: String
    public let groupsStatus: String
    public let isPageAdmin: Int
    public let groupsType: String
    public let eventType: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case type = "type"
        case invitePrivacy = "invite_privacy"
        case memberPrivacy = "member_privacy"
        case postPrivacy = "post_privacy"
        case groupsStatus = "groups_status"
        case isPageAdmin = "is_page_admin"
        case groupsType = "groups_type"
        case eventType = "event_type"
    }

    public init(id: Int, name: String, username: String, type: String, invitePrivacy: String, memberPrivacy: String, postPrivacy: String, groupsStatus: String, isPageAdmin: Int, groupsType: String, eventType: String) {
        self.id = id
        self.name = name
        self.username = username
        self.type = type
        self.invitePrivacy = invitePrivacy
        self.memberPrivacy = memberPrivacy
        self.postPrivacy = postPrivacy
        self.groupsStatus = groupsStatus
        self.isPageAdmin = isPageAdmin
        self.groupsType = groupsType
        self.eventType = eventType
    }
}

public enum Username: String, Codable {
    case alexxender = "alexxender"
    case sourabh = "sourabh"
}

public enum UsersName: String, Codable {
    case alexXender = "Alex Xender"
    case sourabh = "sourabh"
}

public enum UsersType: String, Codable {
    case user = "user"
}

