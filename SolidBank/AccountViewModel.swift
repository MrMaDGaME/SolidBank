//
//  AccountViewModel.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 11/11/2024.
//


import Foundation

class AccountViewModel: ObservableObject {
    @Published var accounts: [Account] = []

    init() {
        loadAccounts()
    }

    func addAccount(name: String) {
        let newAccount = Account(name: name)
        accounts.append(newAccount)
        saveAccounts()
    }

    func deleteAccount(at indexSet: IndexSet) {
        accounts.remove(atOffsets: indexSet)
        saveAccounts()
    }

    func transfer(from source: Account, to destination: Account, amount: Double) {
        if let sourceIndex = accounts.firstIndex(where: { $0.id == source.id }),
           let destinationIndex = accounts.firstIndex(where: { $0.id == destination.id }) {
            if accounts[sourceIndex].balance >= amount {
                accounts[sourceIndex].balance -= amount
                accounts[destinationIndex].balance += amount
                saveAccounts()
            }
        }
    }

    func addFunds(to account: Account, amount: Double) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].balance += amount
            saveAccounts()
        }
    }

    func makePayment(from account: Account, amount: Double) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            if accounts[index].balance >= amount {
                accounts[index].balance -= amount
                saveAccounts()
            }
        }
    }

    private func saveAccounts() {
        if let encoded = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(encoded, forKey: "accounts")
        }
    }

    private func loadAccounts() {
        if let savedAccounts = UserDefaults.standard.data(forKey: "accounts"),
           let decoded = try? JSONDecoder().decode([Account].self, from: savedAccounts) {
            accounts = decoded
        }
    }
}
