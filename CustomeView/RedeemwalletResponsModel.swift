//
//  RedeemwalletResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - RedeemwalletResponsModel
public struct RedeemwalletResponsModel: Codable {
    public let success: Bool
    public let data: DataRedeemClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataRedeemClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataRedeemClass: Codable {
    public let currentPage: Int
    public let data: [DatumRedeem]
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

    public init(currentPage: Int, data: [DatumRedeem], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
public struct DatumRedeem: Codable {
    public let id: Int
    public let date: String
    public let title: String
    public let coin: Int
    public let status: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "date"
        case title = "title"
        case coin = "coin"
        case status = "status"
    }

    public init(id: Int, date: String, title: String, coin: Int, status: String) {
        self.id = id
        self.date = date
        self.title = title
        self.coin = coin
        self.status = status
    }
}
