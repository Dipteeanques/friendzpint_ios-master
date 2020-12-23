
//
//  Constant.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import Foundation


let Domain                      =             "http://www.friendzpoint.com/api/v1"
//let Domain                      =             "http://164.68.113.35/~beta/frp/api/v1"
//let Domain                      =             "192.168.0.70/friendzpoint_web/login"

let helpSuport          =             "https://www.friendzpoint.com/contact?help_support=1"
let TermsOfservice      =             "https://www.friendzpoint.com/terms-of-service?help_support=1"
let Privacy             =             "https://www.friendzpoint.com/privacy-and-policy?help_support=1"

let tellWallet = "https://wallet.bizzbrains.com/api"


let XAPI                        =             "jwZryAdcrffggf867DnjhjhfRvsfhjs5667"

let ACCEPT                      =             "application/json"

let GETAPPVERSION               =             Domain + "/getAppVersion"

let GETADSIMAGE                 =             Domain + "/getAdsImage"


//MARK: - All Api
let REGISTER                    =             Domain + "/register"
let LOGIN                       =             Domain + "/login"
let LOGOUT                      =             Domain + "/logout"
let CHANGE_PASSWORD             =             Domain + "/userChangepassword"
let PASSWORD_EMAIL              =             Domain + "/password/email"
let BROWSE                      =             Domain + "/browse"


//MARK: - Timeline
let SHOWFEED                    =             Domain + "/showFeed?type=ios"
let LIKEPOST                    =             Domain + "/likePost"
let POSTCOMMENT                 =             Domain + "/postComment_v2"
let TIMELINE_COMMENTS           =             Domain + "/timeline_comments_v2"
let PARENT_TIMELINE_COMMENTS    =             Domain + "/parent_timeline_comments_v2"
let USERNAMEWISESEARCH          =             Domain + "/usernamewiseSearch"
let POSTBYID                    =             Domain + "/postbyid"
let POSTLISKELIST               =             Domain + "/postLikeList"



let LIKECOMMENT                 =             Domain + "/likeComment"
let DELETEPOST                  =             Domain + "/deletePost"
let EDITPOST                    =             Domain + "/editPost"
let HIDEPOST                    =             Domain + "/hidePost"
let SAVEPOST                    =             Domain + "/savePost"
let REPORTPOST                  =             Domain + "/reportPost"
let GETNOTIFICATIONs            =             Domain + "/getNotifications"
let SHAREPOST                   =             Domain + "/sharePost"
let GETNOTIFICATIONSUSERLIST    =             Domain + "/getNotificationsUsersList"
let HOMESEARCH                  =             Domain + "/homeSearch"
let MARKALLNOTIFICATION         =             Domain + "/markAllNotification"
let DISLIKEPOST                 =             Domain + "/dislikePost"


//MARK: - friend Request
let FOLLOWREQUEST               =             Domain + "/followRequest"
let FOLLOW_ACCEPT               =             Domain + "/follow-accept"
let FOLLOW_REJECT               =             Domain + "/follow-reject"
let MYFRIENDS                   =             Domain + "/myFriends"
let following               =             Domain + "/following"
let followers               =          Domain + "/followers"

let REMOVEFRIENDS               =             Domain + "/RemoveFriends"
let USER_SEARCH_TAG             =             Domain + "/user_search_tag"
let USERFOLLOWREQUEST           =             Domain + "/userFollowRequest"
let FINDSUGGESTEDUSERS          =             Domain + "/FindsuggestedUsers"


//MARK : - Post
let CREATEPOST                  =             Domain + "/createPost"
let PRIVATE_CONVERSATION        =             Domain + "/get-private-conversation"


//MARK: - create group
let SHOWTIMELINE                 =             Domain + "/showTimeline"
let GROUPLIST                    =             Domain + "/groupsList"
let CREATEGROUP                  =             Domain + "/CreateGroup"
let JOINGROUPLIST                =             Domain + "/joinGroupslist"
let JOINGROUPREMOVE              =             Domain + "/joinGroup"
let MYGROUPDETAILS               =             Domain + "/MyGroupDetails"
let GET_USERS                    =             Domain + "/get-users"
let GROUPADMINLIST               =             Domain + "/groupadminlist"
let MEMBERGROUP                  =             Domain + "/memberGroup"
let ADD_MEMBERGROUP              =             Domain + "/add-memberGroup"
let GETGROUPMEMBER               =             Domain + "/getGroupMember"
let MEMBER_UPDATE_ROLE           =             Domain + "/member/update-role"
let GROUPJOINREQUESTLIST         =             Domain + "/GroupJoinRequestslist"
let GROUPJOINACCEPT              =             Domain + "/GroupJoinAccept"
let GROUPJOINREJECT              =             Domain + "/GroupJoinReject"
let GROUP_SETTINGS_GENERAL       =             Domain + "/group-settings/general"
let GROUP_SETTINGS_UPDATEGENERAL =             Domain + "/group-settings/updategeneral"
let GROUPDELETE                  =             Domain + "/GroupDelete"



//MARK: - Page
let MY_LIKED_PAGES              =             Domain + "/my-liked-pages"
let PAGE_LIKED                  =             Domain + "/page-liked"
let PAGE_CATEGORY               =             Domain + "/page-category"
let CREATE_PAGE                 =             Domain + "/create-page"
let MYCREATEPAGELIST            =             Domain + "/MyCreatePageList"
let PAGE_GENERAL                =             Domain + "/pages/general"
let MYJOINPAGELIST              =             Domain + "/MyJoinPageList"
let UNJOINPAGE                  =             Domain + "/unjoinPage"
let GET_MEMBERS_JOIN            =             Domain + "/get-members-join"
let GETPAGEMEMBER               =             Domain + "/getPageMember"
let GETPAGEADMIN                =             Domain + "/getPageAdmin"
let PAGE_LIKES                  =             Domain + "/page-likes"
let MEMBER_UPDATEPAGE_ROLE      =             Domain + "/member/updatepage-role"
let ADD_PAGE_MEMBERS            =             Domain + "/add-page-members"
let PAGES_UPDATEGENERAL         =             Domain + "/pages/updategeneral"
let PAGE_REPORT                 =             Domain + "/page-report"
let PAGE_DELETE                 =             Domain + "/page-delete"




//MARK: - Setting Api
let GETUSERGENERALSETTING       =             Domain + "/GetUserGeneralSettings"
let SAVEUSERGENERALSETTINGS     =             Domain + "/saveUserGeneralSettings"
let GETUSERPRIVACY              =             Domain + "/GetUserPrivacy"
let SAVEUSERPRIVACY             =             Domain + "/SaveUserPrivacy"
let DEACTIVEACCOUNT             =             Domain + "/deactivateAccount"

let CHANGEAVATAR                =             Domain + "/ChangeAvatar"
let CHANGECOVER                 =             Domain + "/ChangeCover"


//MARK: - Profile
let MYPROFILEDETAILS            =             Domain + "/MyProfileDetails"
let MYTIMELINELIST              =             Domain + "/MyTimelineList"
let TIMEZONELIST                =             Domain + "/timezonelist"


//MARK: - Events
let EVENT_GUESTS                =             Domain + "/event-guests"
let EVENTS                      =             Domain + "/events"
let CREATE_EVENT                =             Domain + "/create-event"
let EVENT_DELETE                =             Domain + "/event-delete"
let EVENT_SETTINGS              =             Domain + "/event-settings"
let GET_MEMBERS_INVITE          =             Domain + "/get-members-invite"
let ADD_EVENT_MEMBERS           =             Domain + "/add-event-members"
var EVENT_SETTINGS_SAVE         =             Domain + "/event-settings-save"
var JOIN_UNJOIN_EVENT           =             Domain + "/join-unjoin-event"


//MARK: - Album photos
let ALBUM_MYALBUMLIST           =             Domain + "/album/myalbumList"
let ALBUM_MYALBUMDETAILS        =             Domain + "/album/MyAlbumDetails"
let ALBUM_DELETE_PHOTOS         =             Domain + "/album/delete-photos"
let ALBUM_CREATE                =             Domain + "/album/create"
let ALBUM_DELETE                =             Domain + "/album/delete"
let ALBUM_EDIT                  =             Domain + "/album/edit"
let ALBUM_EDITSAVE              =             Domain + "/album/editsave"


//MARK: - ChatPart
let GET_MESSAGES                =             Domain + "/get-messages"
let GET_CONVERSATION            =             Domain + "/get-conversation"
let POST_MESSAGE                =             Domain + "/post-message"
let CHATNOTIFICATION            =             Domain + "/chatnotification"

let UNSHAREPOST                 =             Domain + "/unsharePost"

let FindsuggestedGroups         =             Domain + "/FindsuggestedGroups"
let FindsuggestedPages          =             Domain + "/FindsuggestedPages"

let tellZLogin  = tellWallet + "/login"
let tellzverify_otp = tellWallet + "/verify_otp"
let mywallet = tellWallet + "/mywallet"
let myredeems = tellWallet + "/myredeems"
let withdraw_history = tellWallet + "/withdraw_history"
let withdraw_money = tellWallet + "/withdraw_money"
let convert_coin_money = tellWallet + "/convert_coin_money"


let Advertise = Domain + "/advertisementPlans"
let ActivePlan = Domain + "/MyActivePlan"


let rupee = "\u{20B9}"

//MARK: - User Default
let loggdenUser = UserDefaults.standard

let TOKEN              =           "TOKEN"
let Islogin            =           "Islogin"
let USERNAME           =           "USERNAME"
let NAMELOgin          =           "NAMELOgin"
let TimeLine_id        =           "TimeLine_id"
let FRIENDSUSERNAME    =           "FRIENDSUSERNAME"
let GROUPUSERNAME      =           "GROUPUSERNAME"
let PROFILE            =           "PROFILE"
let COVER              =           "COVER"
let STORETIMELINE      =           "STORETIMELINE"
let GROUPID            =           "GROUPID"
let PAGEID             =           "PAGEID"
let PAGEUSERNAME       =           "PAGEUSERNAME"
let EVENTID            =           "EVENTID"
let EVENTUSERNAME      =           "EVENTUSERNAME"
let AD                 =           "AD"
let FCMTOKEN           =           "FCMTOKEN"
let POSTDETAILS        =           "POSTDETAILS"
let BADGECOUNT         =           "BADGECOUNT"
let ADtimeline         =           "ADtimeline"
let ADlikepage         =           "ADlikepage"
let ADjoingroup        =           "ADjoingroup"
let ADbio              =           "ADbio"
let UPDATEPROFILE      =           "UPDATEPROFILE"
let EMAIL              =           "EMAIL"

let walletLoginTellz = "walletLoginTellz"
let walletToken = "walletToken"
let mobNumberWallet = "mobNumberWallet"


let BEARER             =           "Bearer "




//MARK:- BUNDLE VERSION

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}
