//
//  ControladorCatrinaGestionVentanas.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 29/10/24.
//

import ARKit
import SwiftUI
import RealityKit
import Observation
import CatrinaModelos


extension ControladorCatrina {
    func se_ha_cerrado_espacio_imersivo(){
        print("estamos indicando que se cerro el espacio imersivo")
        estado_actual = .espacio_cerrado
        espacio_imersivo_activo = false
    }
    
    func se_abrio_esapcio_imersivo(){
        estado_actual = .espacio_abierto
        espacio_imersivo_activo = true
    }
}
