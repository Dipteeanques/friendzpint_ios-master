//
//  AdvertiseResponseModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 24/06/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - AdvertiseResponsModel
public struct AdvertiseResponsModel: Codable {
    public let success: Bool
    public let data: [DatumAds]
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: [DatumAds], message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - Datum
public struct DatumAds: Codable {
    public let id: Int
    public let packageName: String
    public let price: Int
    public let days: Int
    public let datumDescription: String
    public let isActive: Int
    public let createdAt: String
    public let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case packageName = "package_name"
        case price = "price"
        case days = "days"
        case datumDescription = "description"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(id: Int, packageName: String, price: Int, days: Int, datumDescription: String, isActive: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.packageName = packageName
        self.price = price
        self.days = days
        self.datumDescription = datumDescription
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
