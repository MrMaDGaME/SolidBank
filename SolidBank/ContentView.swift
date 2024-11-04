//
//  ContentView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 28/10/2024.
//
import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var sharedValue: Int = 0
    
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
                .foregroundColor(Color.green)
            TextField("Entrez une valeur", value: $sharedValue, formatter: NumberFormatter())
                .keyboardType(.numberPad)

                        Button("Enregistrer pour le widget") {
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
