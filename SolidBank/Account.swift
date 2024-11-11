//
//  Account.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import Foundation

struct Account: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var balance: Double = 0.0
}
