//
//  ControladorCatrina.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 15/10/24.
//
import Foundation
import UIKit
import ARKit
import AVKit
import Combine
import OSLog
import RealityKit
import SwiftUI

import CatrinaModelos


let log = Logger(subsystem: "ControladorCatrina", category: "general")

@Observable
@MainActor
public class ControladorCatrina{
    var estado_actual: EstadosControladorCatrina = .iniciando_carga
    public var contenido_vista: RealityViewContent?
    var sesion: ARKitSession = ARKitSession()
    var mapa_entidades: [UUID : Entity] = [:]
    var informacion_del_mundo = WorldTrackingProvider()
    
    /// Seccion para guardar pantallas y referencias a otras cosas
    public var espacio_imersivo_activo = false
    
    var vestido_siendo_mostrado: Entity?
    var vestido_seleccionado: Entity?
    var particulas_seleccion: Entity?

    var proveedor_seguimiento_imagenes = ImageTrackingProvider(
        referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "ubicacion_vestidos")
    )
    
    /// var vestidos = [UUID: ModelEntity]()
    //var vestidos: Array<Entity> = []
    
    public var calaca_raiz: Entity = Entity()
    public var vitral: Entity = Entity()
    public var vitralera: [String : Entity] = [:]
    //public var vitralera: Array<Entity> = []

    init(){
        calaca_raiz.name = "calaca_raiz"
        vitral.name = "vitral"
        
        Task.detached(priority: .high){
            do{
                try await self.sesion.run([self.informacion_del_mundo])
            }
            catch{
                // log.error(error)
            }
            await self.cargar_vestidos_y_maniqui()
        }
    }
    
    func cargar_vestidos_y_maniqui() async {
        defer {
            print("Se ha finalizado la carga de elementos")
            estado_actual = .carga_finalizada
            let entidad_cache = Entity()
            entidad_cache.name = "Vestido1"
            se_ha_seleccionado_vestido(entidad_cache)
        }
        
        for vestido in imagenes_y_vestidos{
            guard let vestido_cargado = try? await Entity(named: vestido.modelo, in: catrinaModelosBundle) else {
                fatalError("No se logro cargar el vestido \(vestido.modelo)")
            }
            
            vitralera[vestido.imagen] = vestido_cargado
        }
        
        guard let particulas = try? await Entity(named: "particulas_seleccion", in: catrinaModelosBundle) else {
            fatalError("No se han encontrado las particulas de selección")
        }
        
        particulas_seleccion = particulas
                
        guard let maniqui = try? await Entity(named: nombre_catrina_a_vestir, in: catrinaModelosBundle) else {
            fatalError()
        }
        calaca_raiz.addChild(maniqui)
        
        maniqui.position = [0, 0, -2.5]
        maniqui.scale *= [1, 1, 1]
        
        guard let posicion_vitral = try? await Entity(named: "vitral", in: catrinaModelosBundle) else {
            fatalError()
        }
        vitral.addChild(posicion_vitral)
    }
    
    func se_ha_seleccionado_vestido(_ id: Entity){
        let nombre_vestido = id.name
        
        vestido_seleccionado?.findEntity(named: "particulas_posicion")?.removeChild(particulas_seleccion!)
        
        vestido_seleccionado = id
        
        vestido_seleccionado?.findEntity(named: "particulas_posicion")?.addChild(particulas_seleccion!)

        guard let ubicacion = calaca_raiz.findEntity(named: ubicacion_para_poner_vestido) else {
            fatalError("No se encontro donde poner el vestido")
        }
        
        if vestido_siendo_mostrado != nil {
            ubicacion.removeChild(vestido_siendo_mostrado!)
        }
        
        guard let vestido = vitralera[nombre_vestido] else {
            fatalError("Error: \(#function) no ha podido encontrar vestido con imagen id \(id)")
        }

        vestido_siendo_mostrado = vestido
        
        ubicacion.addChild(vestido_siendo_mostrado!, preservingWorldTransform: false)
        
        
        //calaca_raiz.addChild(vestidos[0])
        print("---Ejecutando la funcion \(#function)---")
    }
}
