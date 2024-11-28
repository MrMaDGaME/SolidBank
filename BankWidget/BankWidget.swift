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

struct AccountWidgetView: View {
    let entry: AccountEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            VStack {
                Text(entry.widgetAccount.account.name)
                    .font(.headline)
                Text("Solde: $\(entry.widgetAccount.account.balance, specifier: "%.2f")")
                    .font(.subheadline)
            }
            .padding()
        case .systemMedium:
            HStack {
                Text(entry.widgetAccount.account.name)
                    .font(.largeTitle)
                Text(" : $\(entry.widgetAccount.account.balance, specifier: "%.2f")")
                    .font(.title)
            }
            .padding()
        default:
            Text("Non supporté")
                .padding()
        }
    }
}

struct BankWidget: Widget {
    let kind: String = "BankWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectAccountIntent.self, provider: AccountTimeline()) { entry in
            if #available(iOS 17.0, *) {
                AccountWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AccountWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Solde d'un compte")
        .description("Affiche le solde d'un compte.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    BankWidget()
} timeline: {
    AccountEntry(date: .now, widgetAccount: WidgetAccount.allAccounts.first!)
}
