//
//  ContentView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 28/10/2024.
//
import WidgetKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AccountViewModel()
    @State private var accountName: String = ""
    @State private var showDeleteConfirmation: Bool = false
    @State private var accountToDelete: IndexSet?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Nom du compte", text: $accountName)
                Button("Ajouter un compte") {
                    if !accountName.isEmpty {
                        viewModel.addAccount(name: accountName)
                        accountName = ""
                    }
                }
                
                List {
                    ForEach(viewModel.accounts) { account in
                        VStack(alignment: .leading) {
                            Text(account.name)
                                .font(.headline)
                            Text("Solde: $\(account.balance, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                    .onDelete { indexSet in
                        accountToDelete = indexSet
                        showDeleteConfirmation = true
                    }
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Supprimer le compte"),
                        message: Text("Êtes-vous sûr de vouloir supprimer ce compte ?"),
                        primaryButton: .destructive(Text("Supprimer")) {
                            if let indexSet = accountToDelete {
                                viewModel.deleteAccount(at: indexSet)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Divider()
                NavigationLink("Ajouter des fonds", destination: AddFundsView(viewModel: viewModel))
                NavigationLink("Virement entre comptes", destination: TransferView(viewModel: viewModel))
                NavigationLink("Effectuer un paiement", destination: PaymentView(viewModel: viewModel))
            }
            .padding()
            .navigationTitle("Gestion de Comptes Bancaires")
        }
    }
}

#Preview {
    ContentView()
}
