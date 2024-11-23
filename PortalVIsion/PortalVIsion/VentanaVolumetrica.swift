//
//  VentanaVolumetrica.swift
//  PortalVIsion
//
//  Created by Jadzia Gallegos on 12/10/24.
//

import SwiftUI
import RealityKit

/// A view that loads in a 3D model and sets the dimensions of the volumetric window to the same size as the model.
struct VentanaVolumetrica: View {
    @Environment(Catrina.self) private var control_catrina
    /// The length of each side of the cubic volumetric window in meters.
    static let size: CGFloat = 0.5
    
   //static let modelos = ["sin_nombre", "cup_saucer_set"]
    
    @State var modelo: String = "sin_nombre"
    
    @State var modelo_en_pantalla: Entity?
    @State var raiz: RealityViewContent?

    var body: some View {
        // Get the height, width, and depth information
        // of the view with a geometry reader.
        VStack{
            HStack{
                Button(action: {
                    //modelo_en_pantalla?.removeFromParent()
                    print("Se esta pulsando")
                    self.modelo = "sin_nombre"
                    
                    control_catrina.actualizar_llamada()
                }, label: {
                    Text("Cambiar")
                })
                
                GeometryReader3D { geometry in
                    RealityView { content in
                        self.raiz = content
                        
                    } .onChange(of: self.modelo, {
                        //print(self.modelo)
                        self.modelo_en_pantalla?.removeFromParent()
                        
                        Task{
                            do {
                                guard let model = try? await  ModelEntity(named: self.modelo) else {
                                    return
                                }
                                
                                let modelBounds = model.visualBounds(relativeTo: nil)

                                /// The entity's dimensions in local coordinates.
                                let viewBounds = self.raiz?.convert(
                                    geometry.frame(in: .local),
                                    from: .local,
                                    to: .scene
                                )

                                /// The scale of the model for the bounds of the volumetric window.
                                let scale = (viewBounds!.extents / modelBounds.extents).min()

                                // Apply the scale to the model to fill the full size of the window.
                                model.scale *= SIMD3(repeating: scale)

                                // Set the model's position to the bottom of the visual bounding box.
                                model.position.y -= model.visualBounds(relativeTo: nil).min.y

                                // Adjust the model's position on the y-axis to align with the view bounds.
                                model.position.y += viewBounds!.min.y

                                // Add the model to the `RealityView
                                self.raiz!.add(model)
                                
                                modelo_en_pantalla = model
                            }
                            catch {
                                fatalError("a numa algo feo paso")
                                return
                            }
                        }


                        /// The visual bounds of the model.
                    })
                }
                
                Button(action: {
                    //modelo_en_pantalla?.removeFromParent()
                    print("Se esta pulsando_2")
                    self.modelo = "sin_nombre_2"
                    self.control_catrina.cambiar_elemnto()
                }, label: {
                    Text("Cambiar")
                })
            }
        }

        
    }
        
}

#Preview (windowStyle: .volumetric) {
    VentanaVolumetrica()
}
