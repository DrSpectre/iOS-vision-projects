//
//  Catrina.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 14/10/24.
//

import Foundation
import UIKit
import ARKit
import AVKit
import Combine
import OSLog
import RealityKit
import SwiftUI

import RealityKitContent


let logger = Logger(subsystem: "mx.uacj.catrina_vision_os", category: "general")


@Observable
@MainActor
public class Catrina{
    var estado_actual: AppEstados = .iniciando
    public var situacion = 0
    public var rereferencia_contenido: RealityViewContent?
    
    // var sesion: ARKitSession = ARKitSession()
    var sesion: ARKitSession = ARKitSession()

    // var infomracion_del_mundo = WorldTrackingProvider()
    var infomracion_del_mundo = WorldTrackingProvider()

    var entidades_malla = [UUID: ModelEntity]()
    public var pieza_raiz = Entity()
    
    public var partes = [
        Pieza(name: "", key: .parte_inferior, sceneName: "Slide01.usda"),
        Pieza(name: "", key: .parte_media, sceneName: "Slide02.usda"),
        Pieza(name: "", key: .parte_superior, sceneName: "Slide03.usda"),
        // Pieza(name: "", key: .slide4, sceneName: "Slide04.usda"),
        // Pieza(name: "", key: .slide5, sceneName: "Slide05.usda")
    ]
    init() {
        pieza_raiz.name = "Raiz"
        
        Task.detached(priority: .high){
            do{
                try await self.sesion.run([self.infomracion_del_mundo])
            }
            catch{
                //logger.
            }
            
            //await self.cargar_piezas()
            /*
            Task{ @MainActor in
                guard let pieza_objetivo
                
            }
             */
            
            
        }
        
    }
    
    func actualizar_llamada(){
        print("Hola mundo desde el catrina modelo")
        
        situacion += 1
    }
    
    func agregar_catrina_al_mundo() async{
        guard let content = self.rereferencia_contenido else {
            return
        }
        
        if let ubicacion_maniqui_catrina = try? await Entity(named: nombreBaseCatrina, in: realityKitContentBundle) {
            content.add(ubicacion_maniqui_catrina)
            
            guard let CabezaUbicacion = ubicacion_maniqui_catrina.findEntity(named: "Cabeza") else {
                fatalError()
            }
            
            self.pieza_raiz = ubicacion_maniqui_catrina
            ubicacion_maniqui_catrina.position = [0, 1, -2.5] /// Ubicacion     Coordenadas X, Y, Z
            ubicacion_maniqui_catrina.scale *= [1, 1, 1] /// Escala
            

            
            
            /*
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
             */
            
            print("Se ha pulsado \(self.situacion)")
            
            print("hola mundo")
        }
    }
    
    public func cambiar_elemnto(){
        Task{
            do {
                guard let cabeza_nueva = try? await Entity(named: "Cuerpo", in: realityKitContentBundle) else {
                    fatalError("CAbeza no encontrada")
                }
                
                cabeza_nueva.components.set(WorldComponent())
                
                if let cuerpo_modelo = cabeza_nueva.findEntity(named: "Cube"){
                    self.pieza_raiz.findEntity(named: "Cabeza")?.addChild(cuerpo_modelo)
                }
            }
            catch{
                fatalError("Error por auqi en el task de cambiar elemetno")
            }
        }
       
    }
    
}

