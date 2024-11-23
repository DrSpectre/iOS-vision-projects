//
//  VistaDeLaCaja.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 12/10/24.
//


import SwiftUI
import RealityKit
import RealityKitContent

struct VistaDeLaCaja: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var cerrar_ventana

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
            Text("--<--<--")
                .onAppear {
                    print("hola mundo")
                    
                    openWindow(id: "VentanaVolumetrica")
                
                    
                    Task{ @MainActor in
                        /*
                        switch await openImmersiveSpace(id: "ImmersiveView") {
                            case .opened:
                                // Don't set immersiveSpaceState to .open because there
                                // may be multiple paths to ImmersiveView.onAppear().
                                // Only set .open in ImmersiveView.onAppear().
                                break

                            case .userCancelled, .error:
                                // On error, we need to mark the immersive space
                                // as closed because it failed to open.
                                fallthrough
                            @unknown default:
                                // On unknown response, assume space did not open.
                                print("adios mundo")
                     
                        }*/
                        switch await openImmersiveSpace(id: "ImmersionCatrina") {
                            case .opened:
                                // Don't set immersiveSpaceState to .open because there
                                // may be multiple paths to ImmersiveView.onAppear().
                                // Only set .open in ImmersiveView.onAppear().
                                cerrar_ventana(id: "vista_inicial")
                                break

                            case .userCancelled, .error:
                                // On error, we need to mark the immersive space
                                // as closed because it failed to open.
                                fallthrough
                            
                            @unknown default:
                                // On unknown response, assume space did not open.
                                print("adios mundo")
                     
                        }

                        
                        print("ejecutando esto")
                     
                    }
                        
                        //ImmersiveView()
                }
                //if let immersiveContentEntity = try? await Entity(named: "ImmersiveView", in: realityKitContentBundle) {
                //    content.add(immersiveContentEntity)
    }
}
