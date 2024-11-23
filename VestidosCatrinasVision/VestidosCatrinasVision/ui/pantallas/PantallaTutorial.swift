//
//  PantallaTutorial.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 29/10/24.
//


import SwiftUI
import RealityKit


struct PantallaTutorial: View{
    static public let id = "pantallas_tutorial"
    
    var body: some View {
        Group{
            VStack{
                Text("Estamos en el tutorial")
                Text("---x")
                
                Button(action: {
                    print("Hola--txt")
                }, label: {
                    Image("boton")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipped()
                }).frame(width: 50, height: 50, alignment: .center)
                
                
                
            }
        }
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged({value in print("cambiando el darg de a \(value)")})
            .onEnded({value in print("Se finalizo en \(value)")}))
        .onTapGesture {
            print("Musica")
        }
        .background(){
            Image("back_pantalla")
                .resizable(resizingMode: .stretch)
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .containerRelativeFrame(.horizontal)
                .clipped()
            
        }
        /*
        .background() {
            Image("imagen_1")
        }
         */

    }
    
}
