//
//  LoginViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(ItunesApiError)
}
//3)
enum ItunesApiError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}

//MARK: - Response Model
struct ResponseModel<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T?
}
//MARK: - Response Model
struct BasicResponse: Decodable {
    let success: Bool
    let message: String?
}

struct UploadParameterMode {
    let parameterName: String
    let parameterData: Data
    let fileName: String
    let fileMime: String
}

struct ResLogin : Decodable {
    let code: Int
    let message: String
    let data: LoginResponse
}

struct LoginResponse : Decodable {
    let id: Int
    let username: String
    let name: String
    let token: String
    let cover: String
    let avatar: String
}


//My Profile Response Model
struct MyprofileResponseModel : Decodable {
    let success: Bool
    let message: String
    let data: ProfilePersonalRespons
}

struct ProfilePersonalRespons : Decodable {
    let id : Int
    let send_requested: String
    let message_privacy: String
    let check_user: String
    let username: String
    let name: String
    let followers: Int
    let following: Int
    let about: String
    let birthday: String
    let type: String
    let city: String
    let country: String
    let hobbies: String
    let interests: String
    let gender: String
    let designation: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let avatar: String
    let cover: String
    let timeline_ad: [ProfileDetailsTimelineset]
    let notification_counter: Int
//    let timezone: Int//String
//    let is_completed_profile: Int
}

//MARK: - MyTimelineList
struct ProfileDetailsTimelineset: Decodable, Encodable {
    let id: Int
    let timeline_id: Int
    var description: String
    let user_id: Int
    let active: Int
    let location: String
    let type: String
    let created_at: String
    var is_liked: Int
    var is_saved: Int
    var is_notification: Int
    var is_users_shared: Int
    let shared_post_id: Int
    var users_liked_count: Int
    let comments_count: Int
    let users_avatar: String
    let users_name: String
    let username: String
    let users_type: String
    let soundcloud_title: String
    let soundcloud_id: Int
    let youtube_title: String
    let youtube_video_id: String
    let images: [String]
    let users_liked: [LikesetRespons]
    let users_tagged: [userTagpeopelListResponse]
    let is_my_post: Int
    let user_page: [TimelineUnotherResoponseModel]
    let user_group: [TimelineUnotherResoponseModel]
    var users_disliked_count: Int
    var users_disliked: [LikesetRespons]
    var is_disliked: Int
}



//Mark : - Avatar Response Model

struct AvatarResponsePodel : Decodable {
    let success: Bool
    let data: [String]
    let message: String
}


//MARK: - Create Postresponse
struct Createpostrespose : Decodable {
    let success: Bool
    let message: String
    let data: [String]
}



//MArk : - FriendRequestlistModel

struct FriendRequesResponseModel : Decodable {
    let success: Bool
    let message: String
    let data: FriendsdataResponse
}

struct FriendsdataResponse: Decodable {
    let current_page: Int
    let data: [FriendDetailsResponse]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct FriendDetailsResponse: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let created_at: String
    let verified: Int
}


//MARK: - Friends Respons Model
struct FriendListResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: FriendPaginationList
}

//MARK: - FriendPaginationList
struct FriendPaginationList: Decodable {
    let current_page: Int
    let data: [FriendList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

//MARK: - FriendList
struct FriendList: Decodable {
    let id: Int
    let timeline_id: Int
    let verified: Int
    let name: String
    let avatar: String
    let username: String
    var is_follow: Int
}

//MARK: - Notification List Response
struct NotificationResponseModel: Decodable,Encodable {
    let success: Bool
    let message: String
    let data: NotificationPaginationList
}

//MARK: - NotificationPaginationList
struct NotificationPaginationList: Codable {
    let current_page: Int
    let data: [NotificationList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

//MARK: - NotificationList
struct NotificationList : Codable {
    let id: Int
    let user_id: Int
    let notified_by: Int
    let timeline_id: Int
    let description: String
    let type: String
    let created_at: String
    let name: String
    let avatar: String
    let username: String
    let api_notification_data: notiRedirectrespons
}

struct notiRedirectrespons: Decodable,Encodable {
    let redirect_action: String
    let type: String
    let username: String
    let post_id: Int
    let id: Int
    let name: String
    let invite_privacy: String
    let member_privacy: String
    let post_privacy: String
    let groups_status: String
    let is_guest: Int
    let is_page_admin: Int
    let groups_type: String
    let event_type: String
}


//MARK: - JointGroup List Response
struct UserJointGroupResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: UserJointGroupPaginationList
}

//MARK: - JointGroupPaginationList
struct UserJointGroupPaginationList: Decodable {
    let current_page: Int
    let data: [UserJointGroupList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

//MARK: - userJointGroupList
struct UserJointGroupList: Decodable {
    let id: Int
    let timeline_id: Int
    let active: Int
    let type: String
    let member_privacy: String
    let post_privacy: String
    let event_privacy: String
    let created_at: String
    let username: String
    let name: String
    let type_group: String
    let cover_url_custom: String
    let avatar_url_custom: String
    let is_page_admin: Int
    let status: String
}


//MARK: - PageLike List Response
struct UserPageLikeGroupResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: UserPageLikePaginationList
}

//MARK: - PageLikePaginationList
struct UserPageLikePaginationList: Decodable {
    let current_page: Int
    let data: [UserPageLikeList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

//MARK: - userPageLikeList
struct UserPageLikeList: Decodable {
    let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let type: String
    let avatar: String
    let cover: String
    let is_page_admin: Int
    
}

//MARK: - Event List Response
struct UserEventGroupResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: UserEventPaginationList
}

//MARK: - EventPaginationList
struct UserEventPaginationList: Decodable {
    let current_page: Int
    let data: [UserEventList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

//MARK: - userEventList
struct UserEventList: Decodable {
    let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let user_id: Int
    let avatar_url: String
    let active: Int
}

struct AllTimelineResponseModel1: Decodable,Encodable {
    let success: Bool
    let message: String
    let data: [MyTimelineList1]?
}


//MARK: - MyTimelineList
struct MyTimelineList1: Decodable, Encodable {
    let id: Int
    let timeline_id: Int
    var description: String
    let user_id: Int
    let active: Int
    let location: String
    let type: String
    let created_at: String
    var is_liked: Int
    var is_saved: Int
    var is_notification: Int
    var is_users_shared: Int
    let shared_post_id: Int
    var users_liked_count: Int
    var comments_count: Int
    let users_avatar: String
    let users_name: String
    let username: String
    let users_type: String
    let soundcloud_title: String
    let soundcloud_id: Int
    let youtube_title: String
    let youtube_video_id: String
    let images: [String]
    let users_liked: [String]//LikesetRespons
    let users_tagged: [userTagpeopelListResponse]
    let is_my_post: Int
    let user_page: TimelineUnotherResoponseModel?
    let user_group: TimelineUnotherResoponseModel?
    var users_disliked_count: Int
    var users_disliked: [LikesetRespons]
    var is_disliked: Int
    var shared_person_name: String
    var shared_username: String
    var is_hide: Int
    var is_report: Int
    var video_poster: String
    var post_link: String
    var is_sponsored: Int
    var post_view_counter: Int
}

struct AllTimelineResponseModel: Decodable,Encodable {
    let success: Bool
    let message: String
    let data: [MyTimelineList]?
}


//

struct GetViewCounterModel:  Decodable{
    let success: Bool
    let message: String
}
//Get Impression

struct GetImpressionModel:  Decodable{
    let success: Bool
    let message: String
    let data: ImpressionData
}

struct ImpressionData: Decodable {

    let post_id: String
    let type: String
}

//MARK: New Post Rsponse

struct NewPostResponseModel: Decodable {

    let success: Bool
    let data: Int
    let message: String
    
}

//MARK: - MyTimeline List Response
struct MyTimelineResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: MyTimelinePaginationList
}

//MARK: - MyTimelinePaginationList
struct MyTimelinePaginationList: Decodable {
    let current_page: Int
    let data: [MyTimelineList]?
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}


//MARK: - MyTimelineList
struct MyTimelineList: Decodable, Encodable {
    let id: Int
    let timeline_id: Int
    var description: String
    let user_id: Int
    let active: Int
    let location: String
    let type: String
    let created_at: String
    var is_liked: Int
    var is_saved: Int
    var is_follow: Int
    var is_notification: Int
    var is_users_shared: Int
    let shared_post_id: Int
    var users_liked_count: Int
    var comments_count: Int
    let users_avatar: String
    let users_name: String
    let username: String
    let users_type: String
    let soundcloud_title: String
    let soundcloud_id: Int
    let youtube_title: String
    let youtube_video_id: String
    let images: [String]
    let users_liked: [String]//LikesetRespons
    let users_tagged: [userTagpeopelListResponse]
    let is_my_post: Int
    let user_page: TimelineUnotherResoponseModel?
    let user_group: TimelineUnotherResoponseModel?
    var users_disliked_count: Int
    var users_disliked: [LikesetRespons]
    var is_disliked: Int
    var shared_person_name: String
    var shared_username: String
    var is_hide: Int
    var is_report: Int
    var video_poster: String
    var post_link: String
    var is_sponsored: Int
    var post_view_counter: Int
}


struct TimelineUnotherResoponseModel: Decodable,Encodable {
    let id: Int?
    let name: String?
    let username: String?
    let type: String?
    let groups_type: String?
    let groups_status: String?
    let is_page_admin: Int?
    let event_type: String?
    let invite_privacy: String?
    let post_privacy: String?
    let member_privacy: String?
}


//MARK: - userTagpeopelListResponse
struct userTagpeopelListResponse: Decodable,Encodable {
    let name: String
    let username: String
    let timeline_id: Int
    let id: Int
    let avatar: String
}


//MARk:- Likepostuser
struct LikesetRespons: Decodable,Encodable {
    let name: String
    let timeline_id: Int
    let id: Int
    let avatar: String
    let username: String
}


//MARK: - FriendsRequest AcceptResponse Model
struct FriendsRequestAcceptResponseModel: Decodable {
    let status: String
    let accepted: Bool
    let message: String
}

//MARK: - FriendsRequest RejectedResponse Model
struct FriendsRequestRejectedResponseModel: Decodable {
    let status: String
    let rejected: Bool
    let message: String
}


//MARK: - postLike Response Model
struct PostLikeResponseModel: Decodable {
    let status: String
    let liked: Bool
    let message: String
    let likecount: String
    let coin: String
}




//MARK: - SharePostResponseModel
struct SharePostResponseModel: Decodable {
    let success: Bool
    let data: sharerespondata
    let message: String
}

struct sharerespondata: Decodable {
    let is_status: Int
}


//MARK: - NotificatioGetandSetResponsModel
struct NotificatioGetandSetResponsModel: Decodable {
    let success: Bool
    let data: ResponsgetSet
    let message: String
}

struct ResponsgetSet: Decodable {
    let post_id: String
    let notifications: Int
}

//MARK; - Post Delete Response Model
struct PostDeleteResponseModel: Decodable,Encodable {
    let success: Bool
    let message: String
    let data: deletedata
}

struct deletedata: Decodable,Encodable {
    let post_id: String
}

//MARK: - RemoveFriendsResponseModel
struct RemoveFriendsResponseModel: Decodable {
    let status: String
    let followed: Bool
    let message: String
}

//MARK: - joinedgroupRemoveReponseModel
struct joinedgroupRemoveReponseModel: Decodable {
    let status: String
    let joined: Bool
    let message: String
}


//MARK: - PagelikedAndUnlikedReponseModel
struct PagelikedAndUnlikedReponseModel: Decodable {
    let status: String
    let liked: Bool
    let message: String
}

//MARK: - PasswordChangeResponseModel
struct PasswordChangeResponseModel: Decodable {
    let success: Bool
    let message: String
}


//MARK: - usergenralSettingModel
struct UsergenralSettingModel: Decodable {
    let success: Bool
    let message: String
    let data: GenralData
}

struct GenralData: Decodable {
    let username: String
    let name: String
    let about: String
    let email: String
    let gender: String
    let country: String
    let city: String
    let birthday: String
    let designation: String
    let hobbies: String
    let interests: String
    let facebook_link: String
    let youtube_link: String
    let twitter_link: String
    let instagram_link: String
    let dribbble_link: String 
    let linkedin_link: String
    let contactno: String
    let timezone: String    
}



//MARK: - UserPrivacyResponseModel
struct UserPrivacyResponseModel: Decodable {
    let success: Bool
    let message: String
    let data: PrivacyData
}

struct PrivacyData: Decodable {
    let comment_privacy: String
    let follow_privacy: String
    let post_privacy: String
    let timeline_post_privacy: String
    let message_privacy: String
}



//MARK: - hidePostResponsModel
struct hidePostResponsModel: Decodable {
    let success: Bool
    let message: String
    let data: hideDataResponse
}

struct hideDataResponse: Decodable {
    let post_id: String
    let hide: Int
}


//MARK: - SavePostResponsModel
struct SavePostResponsModel: Decodable {
    let success: Bool
    let message: String
    let data: SaveDataResponse
}

struct SaveDataResponse: Decodable {
    let post_id: String
    let type: String
}


//MARK: - ReportPostResponsModel
struct ReportPostResponsModel: Decodable {
    let success: Bool
    let message: String
    let data: ReportDataResponse
}

struct ReportDataResponse: Decodable {
    let post_id: String
    let reported: Int
}


//MARK: - Homesearch Response Model
//struct HomesearchResponseModel: Decodable {
//    let success: Bool
//    let message: String
//    let data: [SearchDataResoponseModel]
//
//}

struct HomesearchResponseModel: Codable {

    let success: Bool
    let data: [SearchDataResoponseModel]
    let message: String

    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        data = try values.decode([SearchDataResoponseModel].self, forKey: .data)
        message = try values.decode(String.self, forKey: .message)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(data, forKey: .data)
        try container.encode(message, forKey: .message)
    }

}

struct SearchDataResoponseModel: Codable {

    let id: Int
    let name: String
    let username: String
    let type: String
    let invite_privacy: String
    let member_privacy: String
    let post_privacy: String
    let groups_status: String
    let is_guest: Int
    let is_page_admin: Int
    let groups_type: String
    let event_type: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case type = "type"
        case invite_privacy = "invite_privacy"
        case member_privacy = "member_privacy"
        case post_privacy = "post_privacy"
        case groups_status = "groups_status"
        case is_guest = "is_guest"
        case is_page_admin = "is_page_admin"
        case groups_type = "groups_type"
        case event_type = "event_type"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        username = try values.decode(String.self, forKey: .username)
        type = try values.decode(String.self, forKey: .type)
        invite_privacy = try values.decode(String.self, forKey: .invite_privacy)
        member_privacy = try values.decode(String.self, forKey: .member_privacy)
        post_privacy = try values.decode(String.self, forKey: .post_privacy)
        groups_status = try values.decode(String.self, forKey: .groups_status)
        is_guest = try values.decode(Int.self, forKey: .is_guest)
        is_page_admin = try values.decode(Int.self, forKey: .is_page_admin)
        groups_type = try values.decode(String.self, forKey: .groups_type)
        event_type = try values.decode(String.self, forKey: .event_type)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(type, forKey: .type)
        try container.encode(invite_privacy, forKey: .invite_privacy)
        try container.encode(member_privacy, forKey: .member_privacy)
        try container.encode(post_privacy, forKey: .post_privacy)
        try container.encode(groups_status, forKey: .groups_status)
        try container.encode(is_guest, forKey: .is_guest)
        try container.encode(is_page_admin, forKey: .is_page_admin)
        try container.encode(groups_type, forKey: .groups_type)
        try container.encode(event_type, forKey: .event_type)
    }

}

//struct SearchDataResoponseModel: Decodable {
//    let id: Int
//    let name: String
//    let username: String
//    let type: String
//    let groups_type: String
//    let groups_status: String
//    let is_page_admin: Int
//    let event_type: String
//    let invite_privacy: String
//    let post_privacy: String
//    let member_privacy: String
//    let is_guest: Int
//
//
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(username, forKey: .username)
//        try container.encode(type, forKey: .type)
//        try container.encode(groups_type, forKey: .groups_type)
//        try container.encode(groups_status, forKey: .groups_status)
//        try container.encode(is_page_admin, forKey: .is_page_admin)
//        try container.encode(event_type, forKey: .event_type)
//        try container.encode(invite_privacy, forKey: .invite_privacy)
//        try container.encode(post_privacy, forKey: .post_privacy)
//        try container.encode(member_privacy, forKey: .member_privacy)
//        try container.encode(is_guest, forKey: .is_guest)
//    }
//}


//MARK: Discover Event
struct MyDiscoverEvent: Decodable {

    let success: Bool
    let data: MyDiscoverEventData
    let message: String

}

struct MyDiscoverEventData: Decodable {

    let current_page: Int
    let data: [MyDiscoverEventDatasub]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int

}



struct MyDiscoverEventDatasub: Codable {

    let id: Int
    let timeline_id: Int
    let event_type: String
    let location: String
    let start_date: String
    let end_date: String
    let active: Int
    let invite_privacy: String
    let timeline_post_privacy: String
    let username: String
    let type: String
    let name: String
    let avatar_url: String
    let cover_url: String
    let is_hosting: Int
    let is_going: Int
    let is_guest: Int

}

//MARK: MygroupList Response
struct MygroupListResponse : Decodable {
    let success: Bool
    let data: GroupPagenation
    let message: String
}

struct GroupPagenation: Decodable {
    let current_page: Int
    let data: [MyGroupList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct MyGroupList: Decodable {
    let id: Int
    let timeline_id: Int
    let type_group: String
    let type: String
    let username: String
    let name: String
    let cover_url_custom: String
    let avatar_url_custom: String
    let member_privacy: String
    let post_privacy: String
    let event_privacy: String
}



//MARK: TimelineComment Response Model
struct TimelineCommentResponseModel : Decodable,Encodable {
    let success: Bool
    let message: String
    let data: commentPagenation
}

struct commentPagenation: Decodable,Encodable {
    let current_page: Int
    let data: [CommentList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct CommentList: Decodable,Encodable {
    let id: Int
    let post_id: Int
    let description: String
    let user_id: Int
    let user_name: String
    let user_avatar: String
    let username: String
    let parent_comments_count: Int
    let comments_type: Int
    let created_at: String
    var is_liked: Int
    var replyCommects: [ParentCommentList]?
}


//MARK: - create Comment Response Model
struct CreateCommentResponseModel: Decodable,Encodable {
    let success: Bool
    let data: CommentList
    let message: String
}

struct ParentCommentListCommentResponseModel: Decodable,Encodable {
    let success: Bool
    let data: ParentCommentList
    let message: String
}




//MARK: - ParentCommentResponsModel
struct ParentCommentResponsModel: Decodable,Encodable {
    let success: Bool
    let data: CommentsubPagination
    let message: String
}

struct CommentsubPagination: Decodable,Encodable {
    let current_page: Int
    let data: [ParentCommentList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct ParentCommentList: Decodable,Encodable {
    let id: Int
    let post_id: Int
    let parent_id: Int
    let comments_type: Int
    let description: String
    let user_id: Int
    let user_name: String
    let user_avatar: String
    let username: String
    let created_at: String
    var is_liked: Int
}



//MARK: - TageSearchResponseModel
struct TageSearchResponseModel: Decodable {
    let success: Bool
    let data: [TagList]
    let message: String
}
struct TagList: Decodable {
    let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let about: String
    let image: String
}

//MARK: Create Group response Model
struct CreateGroupresponseModel: Decodable {
    let success: Bool
    let data: GroupcreateSucess
    let message: String
}

struct GroupcreateSucess: Decodable {
    let timeline_id: Int
    let type: String
    let active: Int
    let id: Int
    let username: String
    let name: String
}


//MARK: - MygroupDetailsResponseModel
struct MygroupDetailsResponseModel: Decodable {
    let success: Bool
    let data: MygroupDetailsRespons
    let message: String
}

struct MygroupDetailsRespons: Decodable {
    let id: Int
    let username: String
    let timeline_id: Int
    let group_request: String
    let name: String
    let about: String
    let type: String
    let avatar: String
    let cover: String
}

//MARK: - GroupAminListResponse
struct GroupAminListResponse: Decodable {
    let success: Bool
    let data: AdminPagination
    let message: String
}

struct AdminPagination: Decodable {
    let current_page: Int
    let data: [AdminList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct AdminList: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let is_page_admin: Int
    let username: String
}

//MARK: - MemberSearchResponsModel
struct MemberSearchResponsModel: Decodable {
    let success: Bool
    let data: [SearchMember]
    let message: String
}

struct SearchMember: Decodable {
    let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let about: String
    var is_join: Int
    let image: String
}

struct JoinandUnjoinedResponse: Decodable {
    let status: String
    let added: Bool
    let message: String
}

//MARK: - groupMemberListResponseGet
struct groupMemberListResponseGet: Decodable {
    let success: Bool
    let data: MemberGroupPagination
    let message: String
}
struct MemberGroupPagination: Decodable {
    let current_page: Int
    let data: [MemberListGroup]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct MemberListGroup: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let username: String
    let is_page_admin: Int
}

//MARK: - AssignModelResponseModel
struct AssignModelResponseModel: Decodable {
    let success: Bool
    let data: Bool
    let message: String
}

//MARK: - groupJoinedRequestLisModel
struct groupJoinedRequestLisModel: Decodable {
    let success: Bool
    let data: grouprequestlistPagination
    let message: String
}

struct grouprequestlistPagination: Decodable {
    let current_page: Int
    let data: [GroupjoinrequestList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct GroupjoinrequestList: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let username: String
}

//MARK: - groupjoinrequestAcceptModel
struct groupjoinrequestAcceptModel: Decodable {
    let success: Bool
    let data: AcceptedJoingroupRequestd
    let message: String
}
struct AcceptedJoingroupRequestd: Decodable {
    let accepted: Bool
}


//MARK; - groupjoinrequestREjectedtModel
struct groupjoinrequestREjectedtModel: Decodable {
    let success: Bool
    let data: rejectedJoingroupRequestd
    let message: String
}

struct rejectedJoingroupRequestd: Decodable {
    let rejected: Bool
}


//MARK: - GroupreportResponsModel
struct GroupreportResponsModel: Decodable {
    let status: String
    let reported: Bool
    let message: String
}

//MARK: - groupsettingGetresponsModel
struct groupsettingGetresponsModel: Decodable {
    let success: Bool
    let data: GetSettingRespons
    let message: String
}

struct GetSettingRespons: Decodable {
    //let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let about: String
    let type: String
    let member_privacy: String
    let post_privacy: String
    let event_privacy: String
    let avatar: String
    let cover: String
    let is_group_admin: Int
}

//MARK: - ForgotPasswordRespons
struct ForgotPasswordRespons: Decodable {
    let success: Bool
    let message: String
}

//MARK: - PagecategoryResponseModel
struct PagecategoryResponseModel: Decodable {
    let success: Bool
    let data: [CategoryData]
    let message: String
}

struct CategoryData: Decodable {
    let id: Int
    let name: String
}


//MARK: - MypageresponseModel
struct MypageresponseModel: Decodable {
    let success: Bool
    let data: MypagelistPagination
    let message: String
}

struct MypagelistPagination: Decodable {
    let current_page: Int
    let data: [MypageListResponse]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct MypageListResponse: Decodable {
    let id: Int
    let timeline_id: Int
    let type: String
    let username: String
    let name: String
    let cover_url_custom: String
    let avatar_url_custom: String
}


//MARK: - FriendsRequestSentResponsModel
struct FriendsRequestSentResponsModel: Decodable {
    let success: Bool
    let data: followRequestData
    let message: String
    
}

struct FriendsResponsModel: Decodable {
    let success: Bool
    let followed: Bool
    let message: String
    
}

struct followRequestData: Decodable {
    let followrequest: Bool
}


//MARK: GroupDeleteResponsModel
struct GroupDeleteResponsModel: Decodable {
    let success: Bool
    let data: deletedResponsGroup
    let message: String
}

struct deletedResponsGroup: Decodable {
    let deleted: Bool
}


//MARK: - albumResponListModel
struct albumResponListModel: Decodable {
    let success: Bool
    let data: albumPagination
    let message: String
}

struct albumPagination: Decodable {
    let current_page: Int
    let data: [albumlistModel]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct albumlistModel: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let slug: String
    let privacy: String
    let avatar_img: String
    let created_at: String
}


//MARK: - PageProfileDetailsResponseModel
struct PageProfileDetailsResponseModel: Decodable {
    let success: Bool
    let data: PageProfileDetails
    let message: String
}

struct PageProfileDetails: Decodable {
    let id: Int
    let timeline_id: Int
    let timeline_post_privacy: String
    let member_privacy: String
    let username: String
    let cover_url_custom: String
    let avatar_url_custom: String
}

//MARK: - allImageresponseModel
struct allImageresponseModel: Decodable {
    let success: Bool
    let data: imagePaginationrespons
    let message: String
}

struct imagePaginationrespons: Decodable {
    let current_page: Int
    let data: [imagelist]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct imagelist: Decodable {
    let id: Int
    let media_id: Int
    let avatar_img: String
}

//MARK: - PhotosDeleteResponsModel
struct PhotosDeleteResponsModel: Decodable {
    let success: Bool
    let data: [deletePhotoRespons]
    let message: String
}

struct deletePhotoRespons: Decodable {
}


//MARK: - createAlbumResponsModel
struct createAlbumResponsModel: Decodable {
    let success: Bool
    let data: albumcreate
    let message: String
}

struct albumcreate: Decodable {
    let name: String
    let privacy: String
    let about: String
    let timeline_id: Int
    let slug: String
    let updated_at: String
    let created_at: String
    let id: Int
}


//MARK: - albumdeleteResponsemodel
struct albumdeleteResponsemodel: Decodable {
    let success: Bool
    let data: deleteAlbumall
    let message: String
}

struct deleteAlbumall: Decodable {
    let delete: Bool
}


//MARK: - getAlbumeditrespons
struct getAlbumeditrespons: Decodable {
    let success: Bool
    let data: getAlbumEdit
    let message: String
}

struct getAlbumEdit: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let about: String
    let privacy: String
    let img: [String]
}

//MARK: - joinedpagelistresponsmodel
struct joinedpagelistresponsmodel: Decodable {
    let success: Bool
    let data: PagejoinesPaginationrespons
    let message: String
}

struct PagejoinesPaginationrespons: Decodable {
    let current_page: Int
    let data: [PagejoinedList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct PagejoinedList: Decodable {
    let id: Int
    let timeline_id: Int
    let active: Int
    let message_privacy: String
    let member_privacy: String
    let timeline_post_privacy: String
    let created_at: String
    let username: String
    let name: String
    let type: String
    let cover_url_custom: String
    let avatar_url_custom: String
    let is_page_admin: Int
}

//MARK: - pageProfileResponsModel
struct pageProfileResponsModel: Decodable {
    let success: Bool
    let data: pageprofileDetails
    let message: String
}

struct pageprofileDetails: Decodable {
    let username: String
    let name: String
    let about: String
    let type: String
    let phone: String
    let address: String
    let website: String
    let is_page_admin: Int
    let timeline_post_privacy: String
    let member_privacy: String
    let cover_url: String
    let avatar_url: String
    let is_like: Int
    let page_id: Int
    let timeline_id: Int
    let category_name: String
    let category_id: Int
}



//MARK: - removejoinedPageResponseModel
struct removejoinedPageResponseModel: Decodable {
    let status: String
    let join: Bool
    let username: String
    let message: String
}


//MARK: - pageSearchAddmemberrespons
struct pageSearchAddmemberrespons: Decodable {
    let success: Bool
    let data: [searchmemberListPage]
    let message: String
}

struct searchmemberListPage: Decodable {
    let id: Int
    let timeline_id: Int
    let username: String
    let name: String
    let about: String
    var is_join: Int
    let image: String
}


//MARK: - pageMemberListResponseGet
struct pageMemberListResponseGet: Decodable {
    let success: Bool
    let data: MemberpagePagination
    let message: String
}
struct MemberpagePagination: Decodable {
    let current_page: Int
    let data: [MemberListPage]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct MemberListPage: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let username: String
    let type: String
    let is_page_admin: Int
}


//MARK: - Peplelikethis
struct Peplelikethis: Decodable {
    let success: Bool
    let data: PeplelikethisPagination
    let message: String
}

struct PeplelikethisPagination: Decodable {
    let current_page: Int
    let data: [likethispeople]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct likethispeople: Decodable {
    let id: Int
    let timeline_id: Int
    let name: String
    let avatar: String
    let username: String
    let type: String
    let is_friend: Int
}


//MARK: - MyeventList
struct MyeventList: Decodable {
    let success: Bool
    let data: EventpagePagination
    let message: String
}

struct EventpagePagination: Decodable {
    let current_page: Int
    let data: [eventList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct eventList: Decodable {
    let id: Int
    let timeline_id: Int
    let event_type: String
    let location: String
    let start_date: String
    let end_date: String
    let active: Int
    let username: String
    let type: String
    let name: String
    let avatar_url: String
    let cover_url: String
    let invite_privacy: String
    let timeline_post_privacy: String
}


//MARK: - CreateEventResponstModel
struct CreateEventResponstModel: Decodable,Encodable {
    let success: Bool
    let data: creteEventRespons
    let message: String
}

struct creteEventRespons: Codable {
    let timeline_id: Int
    let type: String
    let user_id: Int
    let location: String
    let start_date: String
    let end_date: String
    let invite_privacy: String
    let timeline_post_privacy: String
    let updated_at: String
    let created_at: String
    let id: Int
}




//MARK: - eventDeleteResponsModel
struct eventDeleteResponsModel: Decodable {
    let success: Bool
    let data: deleteEvent
    let message: String
}

struct deleteEvent: Decodable {
    let deleted: Bool
}


//MARK: - eventProfileResponsModel
struct eventProfileResponsModel: Decodable {
    let success: Bool
    let data: eventprofile
    let message: String
}

struct eventprofile: Decodable {
    let id: Int
    let event_id: Int
    let username: String
    let name: String
    let type: String
    let about: String
    let start_date: String
    let end_date: String
    let is_add_members_show: Int
    let location: String
    let event_type: String
    let timeline_post_privacy: String
    let invite_privacy: String
    let cover_url: String
    let date_dis: String
    let hosted_by: String
    let going_label: String
}


//MARK: - TimezoneResponsModel
struct TimezoneResponsModel: Decodable {
    let code: Int
    let message: String
    let data: [String]
}


//MARK: - updateEventRespons
struct updateEventRespons: Decodable,Encodable {
    let success: Bool
    let data: eventUpdate
    let message: String
}

//MARK: - eventUpdate
struct eventUpdate: Codable {
    let username: String
    let name: String
    let type: String
    let about: String
    let location: String
    let start_date: String
    let end_date: String
    let invite_privacy: String
    let timeline_post_privacy: String
}

//MARK:- markedallnotiRespons
struct markedallnotiRespons: Decodable,Encodable {
    let success: Bool
    let data: String
    let message: String
}

//MARK: - commentLikeResponsModel
struct commentLikeResponsModel: Decodable {
    let status: String
    let liked: Bool
    let message: String
    let likecount: Int
}

//MARK: -  EditPostresponsmodel
struct EditPostresponsmodel: Decodable {
    let success: Bool
    let data: editpost
    let message: String
}

struct editpost: Decodable {
    let post_id: String
    var description: String
}


//MARK: - IMgoingrespMosmodel
struct IMgoingrespMosmodel: Decodable {
    let success: Bool
    let data: Bool
    let message: String
}


//MARK: - dislikeResponsModel
struct dislikeResponsModel: Decodable {
    let status: String
    let disliked: Bool
    let message: String
    let dislikecount: String
}


//MARK: - selectedPostDetails
struct selectedPostDetails: Decodable,Encodable {
    let success: Bool
    let data: MyTimelineList
    let message: String
}


//MARK: - postlikeresponsemodelall

struct postlikeresponsemodelall: Decodable {
    let success: Bool
    let message: String
    let data: postlikepageination
}

//MARK: - postlikepageination
struct postlikepageination: Decodable {
    let current_page: Int
    let data: [postlikelistall]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct postlikelistall: Decodable {
    let post_id: Int
    let id: Int
    let gender: String
    let name: String
    let username: String
    let source: String
}


struct messageResponsemodel: Decodable,Encodable {
    let status: String
    let data: responsMsgPagination
}

struct responsMsgPagination: Decodable,Encodable {
    let current_page: Int
    let from: Int
    let last_page: Int
    let per_page: Int
    let to: Int
    let total: Int
    let data: [MessageReponse]
}

struct MessageReponse: Decodable,Encodable {
    let thread_id: Int
    let user_id: Int
    let body: String
    let created_at: String
    let updated_at: String
}

//MARK: - chatNotiResponsModel
struct chatNotiResponsModel: Decodable,Encodable {
    let status: String
    let data: String
}

//MARK: VersionResponsModel
struct VersionResponsModel: Decodable,Encodable {
    let success: Bool
    let data: TwoAppversion
    let message: String
}

//MARK: - TwoAppversion
struct TwoAppversion: Decodable,Encodable {
    let android: android
    let ios: Ios
}

//MARK: - android
struct android: Decodable,Encodable {
    let success: Bool
    let data: String
    let message: String
}

//MARK: - Ios
struct Ios: Decodable,Encodable {
    let success: Bool
    let data: String
    let message: String
}


//MARK: - chatThreadModel
struct chatThreadModel: Decodable,Encodable {
    let status: String
    let data: GetId
}

struct GetId: Decodable,Encodable {
    let id: Int
}


//MARK: - adsbannersmodel
struct adsbannersmodel: Decodable,Encodable {
    let success: Bool
    let data: [adsData]
    let message: String
}

struct adsData: Decodable,Encodable {
    let title: String
    let link: String
    let type: Int
    let active: Int
    let image: String
}



//MARK:- suggestedFriendResponsModel

struct suggestedFriendResponsMode: Decodable {
    let success: Bool
    let data: SuggestdpagePagination
    let message: String
}

struct SuggestdpagePagination: Decodable {
    let current_page: Int
    let data: [suggetedList]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct suggetedList: Decodable {
    let id: Int
    let timeline_id: Int
    let verified: Int
    let name: String
    let avatar: String
    let username: String
    let type: String
}

//MARK:- ArticleList ResponsModel
struct ArticleListResponsModel: Codable {

    let success: Bool
    let data: ArticleListData
    let message: String

}

struct ArticleListData: Codable {

    let current_page: Int
    let data: [ArticleListMaindata]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int

}

struct ArticleListMaindata: Codable {

    let id: Int
    let title: String
    let slug: String
    let description: String
    let type: String
    let video_link: String
    let link: String
    let tag: String
    let created_by: String
    let created_at: String
    let status: String
    let articleimages: Articleimages
    let is_admin: Int
    var like_count: Int
    let comment_count: Int
    var is_like: Int
    let article_web_link: String
    var view_count : Int

}

struct Articleimages: Codable {

    let id: Int
    let images: String
    let article_id: Int
    let full_url: String

}


struct ArticleLikeModel: Codable {
    let success: Bool
    let data: [JSONAny]
    let message: String
}


//MARK: Article Comment Response Model
struct ArticleCommentModel: Codable {

    let success: Bool
    let data: ArticleCommentData
    let message: String

}
struct ArticleCommentData: Codable {

    let current_page: Int
    let data: [ArticleCommentDatamain]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int

}

struct ArticleCommentDatamain: Codable {

    let id: Int
    let comment: String
    let created_by: String
    let profile: String

}


//MARK: MyArticle ResponseModel
struct  MyArticleResponseModel: Codable {

    let success: Bool
    let data: MyArticleData
    let message: String

}

struct MyArticleData: Codable {

    let current_page: Int
    let data: [MyArticleDatamain]
    let from: Int
    let last_page: Int
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int

}

struct MyArticleDatamain: Codable {

    let id: Int
    let title: String
    let slug: String
    let description: String
    let type: String
    let video_link: String
    let link: String
    let tag: String
    let created_by: String
    let created_at: String
    let status: String
    var view_count: Int
    let is_admin: Int
    var like_count: Int
    let comment_count: Int
    var is_like: Int
    let article_web_link: String
    let articleimages: MyArticleArticleimages

}

struct MyArticleArticleimages: Codable {

    let id: Int
    let images: String
    let article_id: Int
    let full_url: String

}

//MARK: Reels Related Videos
struct ReelsShowRelatedVideosResponseModel: Codable {

    var code: Int
    var msg: [ReelsMsg]

}

struct ReelsMsg: Codable {

    var Video: ReelsVideo
    var User: ReelsUser
    var Sound: ReelsSound

}

struct ReelsVideo: Codable {

    var id: String
    var user_id: String
    var fb_id: String
    var description: String
    var video: String
    var thum: String
    var gif: String
    var view: String
    var section: String
    var sound_id: String
    var privacy_type: String
    var allow_comments: String
    var allow_duet: String
    var block: String
    var duet_video_id: String
    var old_video_id: String
    var duration: String
    var created: String
    var like: Int
    var favourite: Int
    var comment_count: Int
    var like_count: Int

}

struct ReelsUser : Codable{//: Decodable

    var id: String
    var timeline_id: String
    var email: String
    var contactno: String
    var wallet_token: String
    var verification_code: String
    var verified: Bool
   // let email_verified: String
    var remember_token: String
    var username: String
    var password: String
    var balance: String
    var birthday: String
    var city: String
    var country: String
    var designation: String
    var hobbies: String
    var interests: String
    var custom_option1: String
    var custom_option2: String
    var custom_option3: String
    var custom_option4: String
    var gender: String
    var active: Bool
    var last_logged: String
    var timezone: String
    var affiliate_id: String
    var language: String
    var facebook_link: String
    var twitter_link: String
    var dribbble_link: String
    var instagram_link: String
    var youtube_link: String
    var linkedin_link: String
    var created_at: String
    var updated_at: String
    var deleted_at: String
    var profile_pic: String
//    let PushNotification: [String]
//    let PrivacySetting: [String]
    var button: String

}

struct ReelsSound: Codable {

    var id: String
    var audio: String
    var duration: String
    var name: String
    var description: String
    var thum: String
    var sound_section_id: String
    var uploaded_by: String
    var publish: String
    var created: String
    var deleted_at: String

}


//MARK: For show sound

struct ShowSoundResponseModel: Codable {

    var code: Int
    var msg: [Msg]

}

struct Msg: Codable {

    var SoundSection: SoundSection
    var Sound: [Sound]

}

struct SoundSection: Codable {

    var id: String
    var name: String

}

struct Sound: Codable {

    var id: String
    var audio: String
    var duration: String
    var name: String
    var description: String
    var thum: String
    var sound_section_id: String
    var uploaded_by: String
    var publish: String
    var created: String
    var deleted_at: String
    var favourite: Int

}


//MARK: Favorite Sound
struct FavoriteSoundResponseModel: Codable {

    let code: Int
    let msg: [FMsg]

}

struct FMsg: Codable {

    let SoundFavourite: SoundFavourite
    let Sound: FSound
    let User: FUser

}

struct SoundFavourite: Codable {

    let id: String
    let user_id: String
    let sound_id: String
    let created: String

}

struct FSound: Codable {

    let id: String
    let audio: String
    let duration: String
    let name: String
    let description: String
    let thum: String
    let sound_section_id: String
    let uploaded_by: String
    let publish: String
    let created: String
    let deleted_at: String

}

struct FUser: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
//    let email_verified: Bool
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let custom_option1: String
    let custom_option2: String
    let custom_option3: String
    let custom_option4: String
    let gender: String
    let active: Bool
    let last_logged: String
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}


//MARK: show section

struct ShowSectionResponseModel: Codable {

    let code: Int
    let msg: [ShowSectionMsg]

}

struct ShowSectionMsg: Codable {

    let Sound: ShowSectionSound

}

struct ShowSectionSound: Codable {

    let id: String
    let audio: String
    let duration: String
    let name: String
    let description: String
    let thum: String
    let sound_section_id: String
    let uploaded_by: String
    let publish: String
    let created: String
    let deleted_at: String
    let favourite: Int

}


//MARK: show comment
struct ShowCommentResponseModel: Codable {

    let code: Int
    let msg: [SMsg]

}

struct SMsg: Codable {

    let VideoComment: VideoComment
    let Video: Video
    let User: User
    let VideoCommentReply: [VideoCommentReply]

}

struct VideoComment: Codable {

    let id: String
    let user_id: String
    let video_id: String
    let comment: String
    let created: String
    let like: Int
    let like_count: Int

}

struct Video: Codable {

    let id: String
    let user_id: String
    let fb_id: String
    let description: String
    let video: String
    let thum: String
    let gif: String
    let view: String
    let section: String
    let sound_id: String
    let privacy_type: String
    let allow_comments: String
    let allow_duet: String
    let block: String
    let duet_video_id: String
    let old_video_id: String
    let duration: String
    let created: String

}

struct User: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
    let email_verified: String
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let custom_option1: String
    let custom_option2: String
    let custom_option3: String
    let custom_option4: String
    let gender: String
    let active: Bool
    let last_logged: String
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}

struct VideoCommentReply: Codable {

    let id: String
    let user_id: String
    let comment_id: String
    let comment: String
    let created: String
    let User: Usercomment
    let like: Int
    let like_count: Int

}

struct Usercomment: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
    let email_verified: Bool
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let custom_option1: String
    let custom_option2: String
    let custom_option3: String
    let custom_option4: String
    let gender: String
    let active: Bool
    let last_logged: String
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}




struct LikeVideoResponseModel: Codable {

    let code: Int
    let msg: LikeVideoMsg

}

struct LikeVideoMsg: Codable {

    let VideoLike: VideoLike
    let Video: LikeVideoVideo
    let User: LikeVideoUser

}

struct VideoLike: Codable {

    let id: String
    let user_id: String
    let video_id: String
    let created: String
    let message: String

}

struct LikeVideoVideo: Codable {

    let id: String
    let user_id: String
    let fb_id: String
    let description: String
    let video: String
    let thum: String
    let gif: String
    let view: String
    let section: String
    let sound_id: String
    let privacy_type: String
    let allow_comments: String
    let allow_duet: String
    let block: String
    let duet_video_id: String
    let old_video_id: String
    let duration: String
    let created: String

}

struct LikeVideoUser: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
    let email_verified: String
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let custom_option1: String
    let custom_option2: String
    let custom_option3: String
    let custom_option4: String
    let gender: String
    let active: Bool
    let last_logged: String
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}


//MARK: Reels Video comment
struct ReelsCommentResponseModel: Codable {

    let code: Int
    let msg: [ReelsCommentMsg]

}

struct ReelsCommentMsg: Codable {

    let VideoComment: ReelsCommentVideoComment
    let Video: ReelsCommentVideo
    let User: ReelsCommentUser
    let VideoCommentReply: [ReelsCommentVideoCommentReply]

}

struct ReelsCommentVideoComment: Codable {

    let id: String
    let user_id: String
    let video_id: String
    let comment: String
    let created: String
    let like: Int
    let like_count: Int

}

struct ReelsCommentVideo: Codable {

    let id: String
    let user_id: String
    let fb_id: String
    let description: String
    let video: String
    let thum: String
    let gif: String
    let view: String
    let section: String
    let sound_id: String
    let privacy_type: String
    let allow_comments: String
    let allow_duet: String
    let block: String
    let duet_video_id: String
    let old_video_id: String
    let duration: String
    let created: String

}

struct ReelsCommentUser: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
//    let email_verified: String
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let custom_option1: String
    let custom_option2: String
    let custom_option3: String
    let custom_option4: String
    let gender: String
    let active: Bool
    let last_logged: String
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}

struct ReelsCommentVideoCommentReply: Codable {

    let id: String
    let user_id: String
    let comment_id: String
    let comment: String
    let created: String
    let User: ReelsCommentUser
    let like: Int
    let like_count: Int

}

//MARK: Send Comment
struct SendReelsCommentResponseModel: Codable {

    let code: Int
//    let msg: ReelsCommentMsg

}

//MARK: Discovry Module
struct userMVC {
    
    let userID:String
    let first_name:String
    let last_name:String
    let gender:String
    let bio:String
    let website:String
    let dob:String
    let social_id:String
    let userEmail:String
    let userPhone:String
    let password:String
    let userProfile_pic:String
    let role:String
    let username:String
    let social:String
    let device_token:String
    let videoCount:String
    let likesCount:String
    let followers:String
    let following:String
    let followBtn:String
}


struct videoMainMVC {
//    video
    let videoID:String
    let videoUserID:String
    let fb_id:String
    let description:String
    let videoURL:String
    let videoTHUM:String
    let videoGIF:String
    let view:String
    let section:String
    let sound_id:String
    let privacy_type:String
    let allow_comments:String
    let allow_duet:String
    let block:String
    let duet_video_id:String
    let old_video_id:String
    let created:String
    let like:String
    let favourite:String
    let comment_count:String
    let like_count:String
    let followBtn:String
    let duetVideoID:String
    
//    user
    let userID:String
    let first_name:String
    let last_name:String
    let gender:String
    let bio:String
    let website:String
    let dob:String
    let social_id:String
    let userEmail:String
    let userPhone:String
    let password:String
    let userProfile_pic:String
    let role:String
    let username:String
    let social:String
    let device_token:String
    let videoCount:String
    let verified:String

    
//    sound
    let soundName:String


}

struct hashTagMVC {
    let id:String
    let name:String
    let views:String
    let favourite:String
}

struct soundsMVC {
    let id:String
    let audioURL:String
    let duration:String
    let name:String
    let description:String
    let thum:String
    let section:String
    let uploaded_by:String
    let created:String
    let favourite:String
    let publish:String
    
    
}



//MARK: Sound Response Model
struct SoundResponseModel: Codable {

    let code: Int
    let msg: [SoundMsg]

}

struct SoundMsg: Codable {

    let Video: SoundVideo
    let User: SoundUser
    let Sound: SSound

}

struct SoundVideo: Codable {

    let id: String
    let user_id: String
    let fb_id: String
    let description: String
    let video: String
    let thum: String
    let gif: String
    let view: String
    let section: String
    let sound_id: String
    let privacy_type: String
    let allow_comments: String
    let allow_duet: String
    let block: String
    let duet_video_id: String
    let old_video_id: String
    let duration: String
    let created: String
    let like: Int
    let favourite: Int
    let comment_count: Int
    let like_count: Int

}

struct SoundUser: Codable {

    let id: String
    let timeline_id: String
    let email: String
    let contactno: String
    let wallet_token: String
    let verification_code: String
    let verified: Bool
    let remember_token: String
    let password: String
    let balance: String
    let birthday: String
    let city: String
    let country: String
    let designation: String
    let hobbies: String
    let interests: String
    let gender: String
    let active: Bool
    let timezone: String
    let affiliate_id: String
    let language: String
    let facebook_link: String
    let twitter_link: String
    let dribbble_link: String
    let instagram_link: String
    let youtube_link: String
    let linkedin_link: String
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let name: String
    let username: String
    let profile_pic: String

}

struct SSound: Codable {

    let id: String
    let audio: String
    let duration: String
    let name: String
    let description: String
    let thum: String
    let sound_section_id: String
    let uploaded_by: String
    let publish: String
    let created: String
    let deleted_at: String

}
