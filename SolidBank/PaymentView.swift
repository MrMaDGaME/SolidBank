//
//  PaymentView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 11/11/2024.
//


import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var selectedAccount: Account?
    @State private var amount: String = ""

    var body: some View {
        VStack {
            Picker("Sélectionner un compte pour le paiement", selection: $selectedAccount) {
                Text("Sélectionner un compte...").tag(nil as Account?)
                ForEach(viewModel.accounts, id: \.self) { account in
                    Text(account.name).tag(account as Account?)
                }
            }
            TextField("Montant pour paiement", text: $amount)
                .keyboardType(.decimalPad)
            Button("Effectuer un paiement") {
                if let account = selectedAccount, let amountValue = Double(amount) {
                    viewModel.makePayment(from: account, amount: amountValue)
                    amount = ""
                }
            }
            .padding()
        }
        .navigationTitle("Effectuer un paiement")
        .padding()
    }
}
