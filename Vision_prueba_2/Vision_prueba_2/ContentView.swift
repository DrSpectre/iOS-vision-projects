//
//  ContentView.swift
//  Vision_prueba_2
//
//  Created by Jadzia Gallegos on 12/10/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
