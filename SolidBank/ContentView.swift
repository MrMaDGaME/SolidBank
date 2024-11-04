//
//  ContentView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 28/10/2024.
//
import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var sharedValue: Float = 0
    // Float formatter to handle decimal inputs
    private var floatFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        
        VStack(spacing: 10.0) {
            Image(.logo)
                .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
                .imageScale(.small)
                .foregroundStyle(.tint)
            Text("SolidBank")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.black)
            HStack {
                            TextField("Entrez une valeur", value: $sharedValue, formatter: floatFormatter)
                                .keyboardType(.decimalPad)  // Use decimal pad for float input
                                .onSubmit {  // Save to UserDefaults when editing completes
                                    let sharedDefaults = UserDefaults(suiteName: "group.com.solidbank")
                                    sharedDefaults?.set(sharedValue, forKey: "sharedValueKey")
                                }
                                .padding(8)

                            Text("$")
                                .foregroundColor(.gray)
                                .padding(.trailing, 4)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()

                  

                        Button("Enregistrer") {
                            if let sharedDefaults = UserDefaults(suiteName: "group.com.solidbank") {
                                sharedDefaults.set(sharedValue, forKey: "sharedValueKey")
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        }
        

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
