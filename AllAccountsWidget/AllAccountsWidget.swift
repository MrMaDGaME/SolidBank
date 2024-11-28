//
//  AllAccountsWidget.swift
//  AllAccountsWidget
//
//  Created by Mathéo Ducrot on 28/11/2024.
//

import WidgetKit
import SwiftUI

struct AllAccountsWidgetEntry: TimelineEntry {
    let date: Date
    let accounts: [Account?]
}
struct AllAccountsWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AllAccountsWidgetEntry {
        AllAccountsWidgetEntry(date: Date(), accounts: [
            Account(name: "Compte Exemple 1", balance: 100.0),
            Account(name: "Compte Exemple 2", balance: 200.0)
        ])
    }
    func getSnapshot(in context: Context, completion: @escaping (AllAccountsWidgetEntry) -> ()) {
        let entry = AllAccountsWidgetEntry(date: Date(), accounts: [
            Account(name: "Compte Exemple 1", balance: 100.0),
            Account(name: "Compte Exemple 2", balance: 200.0)
            ])
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<AllAccountsWidgetEntry>) -> ()) {
        let accountsData = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts")
        var accounts: [Account?] = [nil]
        if let data = accountsData, let decoded = try? JSONDecoder().decode([Account].self, from: data) {
            accounts = decoded
        }
        let entry = AllAccountsWidgetEntry(date: Date(), accounts: accounts)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
struct AllAccountsWidgetEntryView: View {
    var entry: AllAccountsWidgetProvider.Entry

    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if entry.accounts.allSatisfy({ $0 == nil }) {
                    Text("Aucun compte")
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(entry.accounts.prefix(6).compactMap { $0 }, id: \.id) { account in
                        VStack(spacing: 4) {
                            HStack {
                                Text(account.name)
                                    .font(.body)
                                    .lineLimit(1)
                                Spacer()
                                Text("$\(account.balance, specifier: "%.2f")")
                                    .font(.body)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.vertical, 8)
                            Divider()
                        }
                    }
                }
            }
            .padding()
        }
}
struct AllAccountsWidget: Widget {
    let kind: String = "AllAccountsWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AllAccountsWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                AllAccountsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AllAccountsWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Liste de soldes")
        .description("Affiche la liste et le solde de 6 comptes max.")
        .supportedFamilies([.systemLarge])
    }
}
#Preview(as: .systemLarge) {
    AllAccountsWidget()
} timeline: {
    AllAccountsWidgetEntry(date: .now, accounts: [
        Account(name: "Compte Exemple 1", balance: 100),
        Account(name: "Compte Exemple 2", balance: 200)
        ])
}
