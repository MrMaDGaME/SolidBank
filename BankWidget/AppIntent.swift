//
//  AppIntent.swift
//  BankWidget
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import WidgetKit
import AppIntents

struct SelectAccountIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Modifier compte"
    static var description: IntentDescription = IntentDescription("Description")
    
    @Parameter(title: "Selected account")
    var selectedAccount: WidgetAccount?
}
