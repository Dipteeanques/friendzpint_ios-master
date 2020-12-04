//
//  walletLoginTokenResponsModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - WalletLoginTokenResponsModel
public struct WalletLoginTokenResponsModel: Codable {
    public let success: Bool
    public let data: DataWalletLoginTokenClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataWalletLoginTokenClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataWalletLoginTokenClass: Codable {
    public let mobileNumber: String
    public let token: String

    enum CodingKeys: String, CodingKey {
        case mobileNumber = "mobile_number"
        case token = "token"
    }

    public init(mobileNumber: String, token: String) {
        self.mobileNumber = mobileNumber
        self.token = token
    }
}
