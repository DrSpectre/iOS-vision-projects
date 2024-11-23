//
//  ImersionCalacas.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 15/10/24.
//

import SwiftUI
import RealityKit
// import RealityKitContent

@MainActor
struct ImersionCatrina: View {
    static public let id = "EspacioImersivoDeLasCalacas"
    
    @State private var caja = Entity()
    
    @Environment(ControladorCatrina.self) private var controla

    var body: some View {
        // NO se puede llamar de la misma forma para evitar errores en el contraldor como bindable y como una herrmaietna para hacer coas
        @Bindable var control = controla
        
        RealityView { content in
            content.add(control.calaca_raiz)
            
            /*for vitral in control.vitralera{
                content.add(vitral)
            }*/
            //content.add(control.vitrales)
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({
            entidad in
            print("Sandwich")
            print(entidad.entity)
            print("Sandwich")
            controla.se_ha_seleccionado_vestido(entidad.entity)
            
            /// Se debe ajustar la colicion box para evitar problemas de overlaping con los objetos exiwtentes. 

        }))
        /*
        .simultaneousGesture(TapGesture().targetedToAnyEntity().onEnded({
            entidad in
            print("__Enciendendo el simulataneos gesture")
            print(entidad.entity.name)
        }))
         */

        .task {
            await control.procesar_actualizacion_imagenes()
        }
        .task {
            await control.manejar_permisos()
        }
        
        .task { /// Seccionpara cargar el traquesado de imagenes
            await control.correr_sesion()
        }
        
    }
}

#Preview(immersionStyle: .progressive) {
    ImersionCatrina()
        .environment(ControladorCatrina())
}
