//
//  ContentView.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 15/10/24.
//

import SwiftUI
import RealityKit
// import RealityKitContent

struct PantallaPrincipal: View {
    static public let id_pantalla = "PantallaPrincipalIniciarCatrinas"
    
    @Environment(\.openImmersiveSpace) private var abrir_imersion
    @Environment(\.dismissImmersiveSpace) private var cerrar_imersion
    @Environment(\.dismissWindow) private var cerrar_ventana

    @Environment(ControladorCatrina.self) private var controlador

    var body: some View {
        @Bindable var controlador = controlador
        
            VStack {
                switch controlador.estado_actual{
                case .iniciando_carga:
                    Text("Cargando, por favor espera")
                case .carga_finalizada:
                    Text("Carga Finalizada, abriendo espacio")
                    
                case .espacio_abierto:
                    Text("Uy, parece que todo esta bien")
                case .espacio_cerrado:
                    Text("Se ha cerrado el espacio imersivo. Cuando estes listo vuelve a abrirlo pulsando el boton")
                    
                    Button(action: {
                        controlador.se_abrio_esapcio_imersivo()
                    }, label: {
                        Image("boton")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipped()
                    }).frame(width: 100, height: 100)
                        .onTapGesture {
                            print("me han apachurrado")
                        }
                }
                
                

            }
            .background(){
                Image("back_pantalla")
                    .resizable(resizingMode: .stretch)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .containerRelativeFrame(.horizontal)
                    .clipped()
            }
        }
}

#Preview(windowStyle: .automatic) {
    PantallaPrincipal()
}
