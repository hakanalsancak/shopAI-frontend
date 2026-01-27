//
//  ContentView.swift
//  ShopAI
//
//  Main entry point view
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        HomeView()
            .environmentObject(appViewModel)
            .preferredColorScheme(.light) // Force light mode for consistent branding
    }
}

#Preview {
    ContentView()
}
