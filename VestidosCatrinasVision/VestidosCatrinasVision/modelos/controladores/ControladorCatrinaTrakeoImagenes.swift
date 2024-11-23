//
//  ControladorCatrinaTrakeoImagenes.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 20/10/24.
//
import ARKit
import SwiftUI
import RealityKit
import Observation
import CatrinaModelos

import AppTrackingTransparency

public let dimension_caja: Float = 0.5


extension ControladorCatrina {
    func correr_sesion() async {
        do {
            if ImageTrackingProvider.isSupported{
                try await sesion.run([proveedor_seguimiento_imagenes])
                print("[\(type(of: self))] [\(#function)] sesion.run")
            }
            else {
                print("no esta soportado")
                ///print(await sesion.requestAuthorization(for: [.cameraAccess]))
            }
        }
        catch {
            print(error)
            print("Esto no lo deberias ver")
        }
    }
    
    func procesar_actualizacion_imagenes() async {
        print("[\(type(of: self))] [\(#function)] llamada")
        
        for await actualizacion in proveedor_seguimiento_imagenes.anchorUpdates{
            print("[\(type(of: self))] [\(#function)] anchorUpdates")
            print("[nombre: \(actualizacion.self.anchor.referenceImage.name)")
            
            actualizar_imagen(actualizacion.anchor)
        }
    }
    
    private func actualizar_imagen(_ anclaje: ImageAnchor){
        if mapa_entidades[anclaje.id] == nil{
            let vestido = obtener_modelo_de_vesitdo(id: anclaje.referenceImage.name!)
            vestido.scale = [dimension_caja, dimension_caja, dimension_caja]
            
            // Fragmento de codigo diseñado para mostrar la caja
            // let entidad_nueva = ModelEntity(mesh: .generateBox(size: dimension_caja), materials: [SimpleMaterial.init(color: .cyan, isMetallic: true)], collisionShape: .generateBox(size: SIMD3(repeating: dimension_caja)), mass: 0)
            // let entidad_nueva = ModelEntity(
            //     mesh: .generateBox(width: dimension_caja, height: dimension_caja, depth: 2*dimension_caja),
            //     materials: [SimpleMaterial.init(color: SimpleMaterial.Color.init(red: 0, green: 0, blue: 0, alpha: 0), isMetallic: false)],
            //     collisionShape: .generateBox(width: dimension_caja, height: dimension_caja, depth: 2*dimension_caja), mass: 0)
            
            let entidad_nueva = ModelEntity()
            entidad_nueva.collision = CollisionComponent.init(shapes: [ShapeResource.generateBox(width: dimension_caja, height: dimension_caja, depth: 2*dimension_caja)], isStatic: true)
            
            
            entidad_nueva.name = anclaje.referenceImage.name ?? "Algo no esta bien"
            
            entidad_nueva.components.set(InputTargetComponent())
            
            entidad_nueva.addChild(vitral.clone(recursive: true))
            entidad_nueva.findEntity(named: "vitral")?.findEntity(named: "posicion")?.addChild(vestido)
            
            mapa_entidades[anclaje.id] = entidad_nueva
            
            calaca_raiz.addChild(entidad_nueva)
        }
        
        if anclaje.isTracked{
            mapa_entidades[anclaje.id]?.transform = Transform(matrix: anclaje.originFromAnchorTransform)
        }
    }
    
    func manejar_permisos() async {
        // Seccion para solicitar los permios de trackeo
        var permisoss = try await sesion.requestAuthorization(for: ImageTrackingProvider.requiredAuthorizations)
        print(permisoss)
        
        for await evento in sesion.events{
            switch evento{
            case .authorizationChanged(type: _, status: let estado):
                print("Autorizacion cambiada a \(estado)")
                if estado == .denied{
                    print(":( :(")
                }
            case .dataProviderStateChanged(dataProviders: let proveedor, newState: let estado, error: let error):
                print("Proveedor de datos cambiado: \(proveedor), \(estado)")
                
                await self.correr_sesion()
                
                if let error {
                    print("Proveedor de datos ah encotnrado el error:\(error) ")
                }
                
            @unknown default:
                fatalError("Error no econtrado, en evento: \(evento)")
            }
        }
    }
    
    func obtener_modelo_de_vesitdo(id: String) -> Entity{
        guard let modelo_a_entregar = vitralera[id] else {
            fatalError("Fallanado a cargar el modelo con la imagen '\(id)'")
        }
        
        return modelo_a_entregar.clone(recursive: true)
    }
}
