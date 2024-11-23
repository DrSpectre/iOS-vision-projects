//
//  CatrinaImerrsion.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 12/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit


@MainActor
struct ImmersionCatrina: View {
    @State private var caja = Entity()
    private var rais: Entity?
    
    /// Seccionpara el iamge tracking
    let session = ARKitSession()
    let imageInfo = ImageTrackingProvider(
        referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "playingcard-photos")
    )
    
    
    @Environment(Catrina.self) private var control_catrina
    
    static let mundos = ["skybox1", "skybox2", "skybox3", "skybox4"]

    var body: some View {
        @Bindable var control_catrina = control_catrina
        RealityView { content in
            // Add the initial RealityKit content
            control_catrina.rereferencia_contenido = content
            
            await control_catrina.agregar_catrina_al_mundo()
            
            
            
            if ImageTrackingProvider.isSupported {
                Task {
                    try await session.run([imageInfo])
                    for await update in imageInfo.anchorUpdates {
                        updateImage(update.anchor)
                    }
                }
            }


 
        }
    }
    
    


    func updateImage(_ anchor: ImageAnchor) {
        if imageAnchors[anchor.id] == nil {
            // Add a new entity to represent this image.
            let entity = ModelEntity(mesh: .generateSphere(radius: 0.05))
            entityMap[anchor.id] = entity
            rootEntity.addChild(entity)
        }
        
        if anchor.isTracked {
            entityMap[anchor.id]?.transform = Transform(matrix: anchor.originFromAnchorTransform)
        }
    }

}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        //.environment(ImmersiveView())
}
