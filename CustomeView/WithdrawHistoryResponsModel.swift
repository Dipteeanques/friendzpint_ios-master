//
//  WithdrawHistoryResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 14/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - WithdrawHistoryResponsModel
public struct WithdrawHistoryResponsModel: Codable {
    public let success: Bool
    public let data: DataWithdrwHistoryClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataWithdrwHistoryClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataWithdrwHistoryClass: Codable {
    public let currentPage: Int
    public let data: [DatumWithdrwHistory]
    public let firstPageURL: String
    public let from: Int
    public let lastPage: Int
    public let lastPageURL: String
    public let nextPageURL: String
    public let path: String
    public let perPage: Int
    public let prevPageURL: String
    public let to: Int
    public let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }

    public init(currentPage: Int, data: [DatumWithdrwHistory], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
        self.currentPage = currentPage
        self.data = data
        self.firstPageURL = firstPageURL
        self.from = from
        self.lastPage = lastPage
        self.lastPageURL = lastPageURL
        self.nextPageURL = nextPageURL
        self.path = path
        self.perPage = perPage
        self.prevPageURL = prevPageURL
        self.to = to
        self.total = total
    }
}

// MARK: - Datum
public struct DatumWithdrwHistory: Codable {
    public let id: Int
    public let userID: Int
    public let txnID: String
    public let point: Int
    public let amount: Int
    public let status: Int
    public let date: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userID = "user_id"
        case txnID = "txn_id"
        case point = "point"
        case amount = "amount"
        case status = "status"
        case date = "date"
    }

    public init(id: Int, userID: Int, txnID: String, point: Int, amount: Int, status: Int, date: String) {
        self.id = id
        self.userID = userID
        self.txnID = txnID
        self.point = point
        self.amount = amount
        self.status = status
        self.date = date
    }
}



import Foundation

// MARK: - MoneyWithdrawResponsemodel
public struct MoneyWithdrawResponsemodel: Codable {
    public let success: Bool
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
    }

    public init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}
