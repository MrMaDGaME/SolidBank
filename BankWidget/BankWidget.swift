//
//  BankWidget.swift
//  BankWidget
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import WidgetKit
import SwiftUI
import AppIntents

struct AccountEntry: TimelineEntry {
    let date: Date
    let widgetAccount: WidgetAccount
}

struct AccountTimeline: AppIntentTimelineProvider {
    func timeline(for configuration: SelectAccountIntent, in context: Context) async -> Timeline<AccountEntry> {
        let account = configuration.selectedAccount ?? WidgetAccount.allAccounts.first!
        return Timeline(entries: [AccountEntry(date: .now, widgetAccount: account)], policy: .never)
    }
    
    func snapshot(for configuration: SelectAccountIntent, in context: Context) async -> AccountEntry {
        let account = configuration.selectedAccount ?? WidgetAccount.allAccounts.first!
        return AccountEntry(date: .now, widgetAccount: account)
    }
    
    func placeholder(in context: Context) -> AccountEntry {
        AccountEntry(date: .now, widgetAccount: WidgetAccount.allAccounts.first!)
    }
}

struct WidgetAccount: AppEntity {
    var id: String
    var account: Account
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Account"
    static var defaultQuery = WidgetAccountQuery()
    

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(account.name)",
            subtitle: "Solde: \(String(format: "%.2f", account.balance)) $"
        )
    }
    let accountsData = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts")
    
    static let allAccounts: [WidgetAccount] = {
        return WidgetAccount.loadAccountsFromUserDefaults()
    }()
    
    static func loadAccountsFromUserDefaults() -> [WidgetAccount] {
        guard let data = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts") else {
            print("No data found in UserDefaults.")
            return []
        }
        
        do {
            // Decode the data into Account objects
            let accounts = try JSONDecoder().decode([Account].self, from: data)
            
            // Map each Account object to a WidgetAccount instance
            return accounts.map { WidgetAccount(id: $0.id.uuidString, account: $0) }
        } catch {
            print("Failed to decode accounts: \(error)")
            return []
        }
    }
}

struct WidgetAccountQuery: EntityQuery {
    func entities(for identifiers: [WidgetAccount.ID]) async throws -> [WidgetAccount] {
        WidgetAccount.allAccounts.filter{
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [WidgetAccount] {
        WidgetAccount.allAccounts
    }
    
    func defaultResult() async -> WidgetAccount? {
        WidgetAccount.allAccounts.first
    }
}


struct AccountTimeline: AppIntentTimelineProvider {
    func timeline(for configuration: SelectAccountIntent, in context: Context) async -> Timeline<AccountEntry> {
        let account = configuration.selectedAccount ?? WidgetAccount.allAccounts.first!
        return Timeline(entries: [AccountEntry(date: .now, widgetAccount: account)], policy: .never)
    }
    
    func snapshot(for configuration: SelectAccountIntent, in context: Context) async -> AccountEntry {
        let account = configuration.selectedAccount ?? WidgetAccount.allAccounts.first!
        return AccountEntry(date: .now, widgetAccount: account)
    }
    
    func placeholder(in context: Context) -> AccountEntry {
        AccountEntry(date: .now,
                     accounts: [WidgetAccount(id:1, account:(name: "Compte Exemple", balance: 100.0)))
    }
}


struct AccountEntry: TimelineEntry {
    let date: Date
    let widgetAccounts: [WidgetAccount]
}

struct AccountWidgetView: View {
    let entry: AccountEntry

    var body: some View {
        ZStack {
            VStack {
                Text("Solde: \(String(format: "%.2f", entry.widgetAccount.account.balance))$")
                    .font(.headline)
                    .padding(.bottom, 4)
                    

                // Display account name
                Text(entry.widgetAccount.account.name)
                    .font(.subheadline)
            }
            .padding()
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct BankWidget: Widget {
    let kind: String = "BankWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "AccountWidget", intent: SelectAccountIntent.self, provider: AccountTimeline()) {
            entry in AccountWidgetView(entry: entry)
        }
        .configurationDisplayName("Modify Widget")
        .description("Choose Account")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    BankWidget()
} timeline: {
    AccountEntry(date: .now, widgetAccount: WidgetAccount.allAccounts.first!)
}
