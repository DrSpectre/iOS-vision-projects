//
//  VestidosCatrinasVisionApp.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 15/10/24.
//
// Esta pantalla esta diseñada para controlar todas las pantallas y es capaz de abrir y cerrar las
// las demas pantallas disponibles
//

import SwiftUI

@main
struct VestidosCatrinasVisionApp: App {
    @Environment(\.openImmersiveSpace) private var abrir_imersion
    @Environment(\.dismissWindow) private var cerrar_ventana
    @Environment(\.openWindow) private var abrir_ventana
    @State var controlador_catrina = ControladorCatrina()
    
    @State private var immersionStyle: ImmersionStyle = .mixed
    
    var body: some Scene{
        WindowGroup(id: PantallaPrincipal.id_pantalla){
            PantallaPrincipal()
                .environment(controlador_catrina)
                .onChange(of: controlador_catrina.estado_actual) {
                    _ in
                    switch(controlador_catrina.estado_actual){
                    case .carga_finalizada:
                        Task{
                            await abrir_imersion(id: ImersionCatrina.id)
                            cerrar_ventana(id: PantallaPrincipal.id_pantalla)
                            //abrir_ventana(id: PantallaTutorial.id)
                        }
                        
                    case .espacio_cerrado:
                        Task{
                            print("Algo aqui no esta bien")
                            abrir_ventana(id: PantallaPrincipal.id_pantalla)
                        }
                        
                    case .espacio_abierto:
                        Task{
                            await abrir_imersion(id: ImersionCatrina.id)
                            cerrar_ventana(id: PantallaPrincipal.id_pantalla)
                        }
                        
                    default:
                        print("se ha actualziado \(#function)")
                    }
                        
                }
                .frame(minWidth: 50, maxWidth: 1450,
                       minHeight: 50, maxHeight: 850)
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultSize(CGSize(width: 1450, height: 850))
        
        WindowGroup(id: PantallaTutorial.id){
            PantallaTutorial()
                .frame(minWidth: 50, maxWidth: 1450,
                       minHeight: 50, maxHeight: 850)
                .environment(controlador_catrina)
                
                
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultSize(CGSize(width: 1450, height: 850))
        
        ImmersiveSpace(id: ImersionCatrina.id){
            ImersionCatrina()
                .environment(controlador_catrina)
                .onDisappear{
                    controlador_catrina.se_ha_cerrado_espacio_imersivo()
                    Task{
                        abrir_ventana(id: PantallaPrincipal.id_pantalla)
                        // cerrar_ventana(id: PantallaTutorial.id)
                    }
                }
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed)
    }
}
