//
//  ContentView.swift
//  SolidBank
//
//  Created by Mathéo Ducrot on 28/10/2024.
//

import SwiftUI

struct ContentView: View {
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
                
                
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
