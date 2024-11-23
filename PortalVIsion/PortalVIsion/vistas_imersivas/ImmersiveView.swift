//
//  ImmersiveView.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 12/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
struct ImmersiveView: View {
    @State private var caja = Entity()
    static let mundos = ["skybox1", "skybox2", "skybox3", "skybox4"]

    var body: some View {
        HStack{
            Text("-->jfiepjfiape<--")
            
            RealityView { content in
                // Add the initial RealityKit content
                if let CajaDePortales = try? await Entity(named: "PortalBoxScene", in: realityKitContentBundle) {
                    content.add(CajaDePortales)
                    
                    guard let caja = CajaDePortales.findEntity(named: "Caja") else {
                        fatalError()
                    }
                    
                    self.caja = caja
                    caja.position = [0, 1, 0] /// Ubicacion
                    caja.scale *= [1, 1, 1] /// Escala
                    
                    ///Bucle para cargar todas las texturas
                    for mundo_por_dibujar in 1...4 {
                        /// PAra intorducir las texturas
                        let mundo = Entity()
                        mundo.components.set(WorldComponent())
                        
                        let skybox = await  crear_entidad_caja(textura: "skybox\(mundo_por_dibujar)")
                        
                        mundo.addChild(skybox)
                        
                        content.add(mundo)
                        
                        //Crear portal 1
                        let portal_a_mundo = crear_portal(objetivo: mundo)
                        content.add(portal_a_mundo)
                        
                        guard let ancla_portal = CajaDePortales.findEntity(named: "Pared_\(mundo_por_dibujar)") else {
                            fatalError("Error al encotnrar donde poner la pared")
                        }
                        
                        ancla_portal.addChild(portal_a_mundo)
                        
                    }
                    
                    print("hola mundo")
                }
            }
        }

    }
    
    func crear_entidad_caja(textura: String) async -> Entity {
        guard let recurso = try? await TextureResource(named: textura) else {
            fatalError("No se pudo llamar a la funcion para leer la textura")
        }
        
        var material = UnlitMaterial()
        
        material.color = .init(texture: .init(recurso))
        
        let entidad = Entity()
        
        entidad.components.set(ModelComponent(mesh: .generateSphere(radius: 100), materials: [material]))
        
        entidad.scale *= .init(x: -1, y: 1, z: 1)
        
        return entidad
    }
    
    func crear_portal(objetivo: Entity) -> Entity {
        let malla_portal = MeshResource.generatePlane(width: 1, depth: 1)
        let portal = ModelEntity(mesh: malla_portal, materials: [PortalMaterial()])
        
        portal.components.set(PortalComponent(target: objetivo))
        return portal
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        //.environment(ImmersiveView())
}
