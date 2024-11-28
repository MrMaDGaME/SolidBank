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
    static var description: IntentDescription = IntentDescription("Sélectionnez le compte que vous voulez afficher dans le widget.")

    @Parameter(title: "Compte sélectionné")
    var selectedAccount: WidgetAccount?
}
