//
//  AddFundsView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 11/11/2024.
//


import SwiftUI

struct AddFundsView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var selectedAccount: Account?
    @State private var amount: String = ""

    var body: some View {
        VStack {
            Picker("Sélectionner un compte", selection: $selectedAccount) {
                Text("Sélectionner un compte...").tag(nil as Account?)
                ForEach(viewModel.accounts, id: \.self) { account in
                    Text(account.name).tag(account as Account?)
                }
            }
            TextField("Montant pour ajouter des fonds", text: $amount)
                .keyboardType(.decimalPad)
            Button("Ajouter des fonds") {
                if let account = selectedAccount, let amountValue = Double(amount) {
                    viewModel.addFunds(to: account, amount: amountValue)
                    amount = ""
                }
            }
            .padding()
        }
        .navigationTitle("Ajouter des fonds")
        .padding()
    }
}
