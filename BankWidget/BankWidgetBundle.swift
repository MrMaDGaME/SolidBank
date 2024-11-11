//
//  BankWidgetBundle.swift
//  BankWidget
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import WidgetKit
import SwiftUI

@main
struct BankWidgetBundle: WidgetBundle {
    var body: some Widget {
        BankWidget()
        BankWidgetControl()
    }
}
