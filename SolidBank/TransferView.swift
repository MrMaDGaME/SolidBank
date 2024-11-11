//
//  TransferView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 11/11/2024.
//


import SwiftUI

struct TransferView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var selectedSourceAccount: Account?
    @State private var selectedDestinationAccount: Account?
    @State private var amount: String = ""

    var body: some View {
        VStack {
            Picker("Compte source", selection: $selectedSourceAccount) {
                Text("Sélectionner un compte source...").tag(nil as Account?)
                ForEach(viewModel.accounts, id: \.self) { account in
                    Text(account.name).tag(account as Account?)
                }
            }
            Picker("Compte destination", selection: $selectedDestinationAccount) {
                Text("Sélectionner un compte destination...").tag(nil as Account?)
                ForEach(viewModel.accounts, id: \.self) { account in
                    Text(account.name).tag(account as Account?)
                }
            }
            TextField("Montant pour virement", text: $amount)
                .keyboardType(.decimalPad)
            Button("Virement entre comptes") {
                if let source = selectedSourceAccount, let destination = selectedDestinationAccount, let amountValue = Double(amount), source.id != destination.id {
                    viewModel.transfer(from: source, to: destination, amount: amountValue)
                    amount = ""
                }
            }
            .padding()
        }
        .navigationTitle("Virement entre comptes")
        .padding()
    }
}
