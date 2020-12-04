//
//  WalletLoginResponseModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - WalletLoginResponsModel
public struct WalletLoginResponsModel: Codable {
    public let success: Bool
    public let data: DataWalletLoginClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataWalletLoginClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataWalletLoginClass: Codable {
    public let otp: String
    public let mobileNumber: String

    enum CodingKeys: String, CodingKey {
        case otp = "otp"
        case mobileNumber = "mobile_number"
    }

    public init(otp: String, mobileNumber: String) {
        self.otp = otp
        self.mobileNumber = mobileNumber
    }
}
