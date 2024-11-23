//
//  PortalVIsionApp.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 12/10/24.
//

import SwiftUI

@main
struct PortalVIsionApp: App {
    @State private var control_catrina: Catrina = Catrina()
    
    let modificador_altura: CGFloat = 0.25
    
    var body: some SwiftUI.Scene {
        WindowGroup(id: "vista_inicial") {
            VistaDeLaCaja()
                .environment(control_catrina)
        }
        
        WindowGroup(id: "VentanaVolumetrica"){
            VentanaVolumetrica()
                .environment(control_catrina)
        }
        .windowStyle(.plain)
        
        ImmersiveSpace(id: "ImmersiveView"){
            ImmersiveView()
        }
        .windowStyle(.volumetric)
        // Scale the size of window group relative to the volumetric window's size.
        .defaultSize(
            width: VentanaVolumetrica.size,
            height: modificador_altura * VentanaVolumetrica.size,
            depth: VentanaVolumetrica.size,
            in: .meters
        )
        
        ImmersiveSpace(id: "ImmersionCatrina"){
            ImmersionCatrina()
                .environment(control_catrina)
        }
        .windowStyle(.volumetric)
        // Scale the size of window group relative to the volumetric window's size.
        .defaultSize(
            width: VentanaVolumetrica.size,
            height: modificador_altura * VentanaVolumetrica.size,
            depth: VentanaVolumetrica.size,
            in: .meters
        )
        //.defaultPosition(<#T##UnitPoint#>)
    }
}
