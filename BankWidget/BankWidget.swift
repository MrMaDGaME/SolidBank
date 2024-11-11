//
//  BankWidget.swift
//  BankWidget
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import WidgetKit
import SwiftUI

struct BankWidgetEntry: TimelineEntry {
    let date: Date
    let account: Account?
}

struct BankWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> BankWidgetEntry {
        BankWidgetEntry(date: Date(), account: Account(name: "Compte Exemple", balance: 100.0))
    }

    func getSnapshot(in context: Context, completion: @escaping (BankWidgetEntry) -> ()) {
        let entry = BankWidgetEntry(date: Date(), account: Account(name: "Compte Exemple", balance: 100.0))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BankWidgetEntry>) -> ()) {
        let accountsData = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts")
        var account: Account? = nil

        if let data = accountsData, let decoded = try? JSONDecoder().decode([Account].self, from: data) {
            account = decoded.first
        }

        let entry = BankWidgetEntry(date: Date(), account: account)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct BankWidgetEntryView: View {
    var entry: BankWidgetProvider.Entry

    var body: some View {
        VStack {
            if let account = entry.account {
                Text(account.name)
                    .font(.headline)
                Text("Solde: $\(account.balance, specifier: "%.2f")")
                    .font(.subheadline)
            } else {
                Text("Aucun compte sélectionné")
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct BankWidget: Widget {
    let kind: String = "BankWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                BankWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BankWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Solde de Compte Bancaire")
        .description("Affiche le solde d'un compte bancaire.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    BankWidget()
} timeline: {
    BankWidgetEntry(date: .now, account: .init(name: "Compte Exemple", balance: 100))
}
