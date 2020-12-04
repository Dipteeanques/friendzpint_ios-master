//
//  ActivePlanResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 14/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - ActivePlanResponsModel
public struct ActivePlanResponsModel: Codable {
    public let success: Bool
    public let data: DataActivePlan
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataActivePlan, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataActivePlan: Codable {
    public let name: String
    public let activationDate: String
    public let expiryDate: String
    public let isExpire: Int

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case activationDate = "activation_date"
        case expiryDate = "expiry_date"
        case isExpire = "is_expire"
    }

    public init(name: String, activationDate: String, expiryDate: String, isExpire: Int) {
        self.name = name
        self.activationDate = activationDate
        self.expiryDate = expiryDate
        self.isExpire = isExpire
    }
}

