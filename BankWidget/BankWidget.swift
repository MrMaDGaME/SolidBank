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
    let accounts: [Account]
}

struct BankWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> BankWidgetEntry {
        BankWidgetEntry(date: Date(),
                        accounts: [Account(name: "Compte Exemple", balance: 100.0),
                                   Account(name: "Compte Exemple", balance: 152.68)])
    }

    func getSnapshot(in context: Context, completion: @escaping (BankWidgetEntry) -> ()) {
        let entry = BankWidgetEntry(date: Date(),
                                    accounts: [Account(name: "Compte Exemple", balance: 100.0),
                                               Account(name: "Compte Exemple", balance: 152.68)])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BankWidgetEntry>) -> ()) {
        let accountsData = UserDefaults(suiteName: "group.com.solidbank")?.data(forKey: "accounts")
        var accounts: [Account] = [ // Valeurs par défaut en cas d'erreur
            Account(name: "Compte Exemple", balance: 100.0),
            Account(name: "Compte Exemple", balance: 152.68),
            Account(name: "Compte Exemple", balance: 100.0),
            Account(name: "Compte Exemple", balance: 152.68)]

        if let data = accountsData, let decoded = try? JSONDecoder().decode([Account].self, from: data) {
            accounts = Array(decoded.prefix(4))
        }

        let entry = BankWidgetEntry(date: Date(), accounts: accounts)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct BankWidgetEntryView: View {
    var entry: BankWidgetProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily{
        case .systemSmall:
            VStack {
                if let accounts = entry.accounts.first {
                    Text(accounts.name)
                        .font(.headline)
                    Text("Solde: $\(accounts.balance, specifier: "%.2f")")
                        .font(.subheadline)
                } else {
                    Text("Aucun compte sélectionné")
                        .font(.headline)
                }
            }
            .padding()
            
        case .systemMedium:
            HStack {
                ForEach(entry.accounts.prefix(2)) { account in
                    VStack {
                        Text(account.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text("Solde: $\(account.balance, specifier: "%.2f")")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity) // Répartition égale de l'espace
                }
            }
            .padding()
            
        case .systemLarge:
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(entry.accounts.prefix(4)) { account in
                            VStack {
                                Text(account.name)
                                    .font(.headline)
                                Text("Solde: $\(account.balance, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
            
        default:
            Text("Non supporté")
        }
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    BankWidget()
} timeline: {
    BankWidgetEntry(date: .now, accounts: [Account(name: "Compte Exemple", balance: 100),
                                           Account(name: "Compte Exemple", balance: 152.68)])
}
