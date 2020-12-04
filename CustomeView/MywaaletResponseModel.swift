//
//  MywaaletResponseModel.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - MywalletResponsModel
public struct MywalletResponsModel: Codable {
    public let success: Bool
    public let data: DataMywalletClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataMywalletClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataMywalletClass: Codable {
    public let mobileNumber: String
    public let totalCoin: Int
    public let redeemCoin: Int
    public let balance: Int
    public let totalWithdrawBalance: Int

    enum CodingKeys: String, CodingKey {
        case mobileNumber = "mobile_number"
        case totalCoin = "total_coin"
        case redeemCoin = "redeem_coin"
        case balance = "balance"
        case totalWithdrawBalance = "total_withdraw_balance"
    }

    public init(mobileNumber: String, totalCoin: Int, redeemCoin: Int, balance: Int, totalWithdrawBalance: Int) {
        self.mobileNumber = mobileNumber
        self.totalCoin = totalCoin
        self.redeemCoin = redeemCoin
        self.balance = balance
        self.totalWithdrawBalance = totalWithdrawBalance
    }
}
