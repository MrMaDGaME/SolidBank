//
//  BankWidget.swift
//  BankWidget
//
//  Created by Mathéo Ducrot on 11/11/2024.
//

import WidgetKit
import SwiftUI
import AppIntents
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

struct WidgetColor: AppEntity {
    var id: String
    var account: Account
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Account"
    static var defaultQuery = WidgetColorQuery()
    

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(account.name)",
            subtitle: "Solde: \(String(format: "%.2f", account.balance)) $"
        )
    }
    let accountsData = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts")
    
    static let allAccounts: [WidgetColor] = {
        return WidgetColor.loadAccountsFromUserDefaults()
    }()
    
    static func loadAccountsFromUserDefaults() -> [WidgetColor] {
        guard let data = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts") else {
            print("No data found in UserDefaults.")
            return []
        }
        
        do {
            // Decode the data into Account objects
            let accounts = try JSONDecoder().decode([Account].self, from: data)
            
            // Map each Account object to a WidgetColor instance
            return accounts.map { WidgetColor(id: $0.id.uuidString, account: $0) }
        } catch {
            print("Failed to decode accounts: \(error)")
            return []
        }
    }
}


struct WidgetColorQuery: EntityQuery {
    func entities(for identifiers: [WidgetColor.ID]) async throws -> [WidgetColor] {
        WidgetColor.allAccounts.filter{
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [WidgetColor] {
        WidgetColor.allAccounts
    }
    
    func defaultResult() async -> WidgetColor? {
        WidgetColor.allAccounts.first
    }
}

struct SelectColorIntent: WidgetConfigurationIntent{
    static var title:LocalizedStringResource = "Modifier compte"
    static var description:IntentDescription = IntentDescription("Description")
    
    @Parameter(title: "Selected account")
    var accentColor: WidgetColor?
}

struct ColoredTimeline: AppIntentTimelineProvider {
    func timeline(for configuration: SelectColorIntent, in context: Context) async -> Timeline<ColoredEntry> {
        let color = configuration.accentColor ?? WidgetColor.allAccounts.first!
        return Timeline(entries: [ColoredEntry(date: .now, widgetColor: color)], policy: .never)
    }
    
    func snapshot(for configuration: SelectColorIntent, in context: Context) async -> ColoredEntry {
        let color = configuration.accentColor ?? WidgetColor.allAccounts.first!
        return ColoredEntry(date: .now, widgetColor: color)
    }
    
    func placeholder(in context: Context) -> ColoredEntry {
        ColoredEntry(date: .now, widgetColor: WidgetColor.allAccounts.first!)
    }
}


struct ColoredEntry: TimelineEntry{
    let date: Date
    let widgetColor: WidgetColor
}

struct ColoredWidgetView: View {
    let entry: ColoredEntry

    var body: some View {
        ZStack {
            VStack {
                Text("Solde: \(String(format: "%.2f", entry.widgetColor.account.balance))$")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 4)
                    

                // Display account name
                Text(entry.widgetColor.account.name)
                    .font(.subheadline)
                    .foregroundColor(.black)
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
        AppIntentConfiguration(kind: "ColoredWidget",intent: SelectColorIntent.self ,provider: ColoredTimeline() ){
            entry in ColoredWidgetView(entry:entry)
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
    ColoredEntry(date: .now, widgetColor: WidgetColor.allAccounts.first!)
}
