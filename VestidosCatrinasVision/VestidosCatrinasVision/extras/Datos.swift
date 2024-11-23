//
//  Datos.swift
//  VestidosCatrinasVision
//
//  Created by Jadzia Gallegos on 28/10/24.
//

import Foundation

public struct VestidoVitral{
    var imagen: String
    var modelo: String
    
    init(imagen: String, modelo: String) {
        self.imagen = imagen
        self.modelo = modelo
    }
}

public let imagenes_y_vestidos: Array<VestidoVitral> = [
    VestidoVitral(imagen: "imagen_1", modelo: "CatrinaAlebrijes"),
    VestidoVitral(imagen: "ss_p", modelo: "vestido_1"),
    
    /// Carga real de datos para alamacenar
    VestidoVitral(imagen: "Vestido1", modelo: "catrina_vestido_a"),
    VestidoVitral(imagen: "Vestido3", modelo: "catrina_vestido_3"),
    VestidoVitral(imagen: "Vestido5", modelo: "catrina_vestido_alebrijes"),
    VestidoVitral(imagen: "Vestido6", modelo: "catrina_vestido_6"),
    VestidoVitral(imagen: "Vestido4", modelo: "catrina_vestido_4"),
    VestidoVitral(imagen: "Vestido7", modelo: "catrina_vestido_7"),
    /// este no carga bien
    VestidoVitral(imagen: "Vestido8", modelo: "catrina_vestido_8"),

    /// Modelos que faltan arreglar y colcoar
]
