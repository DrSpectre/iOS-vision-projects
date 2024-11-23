import Foundation

/// Enum that tracks the current phase of the game by implementing a simple state machine.
public enum AppEstados: String, Codable, Sendable, Equatable {
    case iniciando         // Launching app
    case cargandoArchivos      // Loading assets from the Reality Composer Pro project
    case esperandoInicar     // At the main menu
    case colocandoBaseCatrina  // Placing the first piece of track
    case colocandoEspaciadoCatrina // Has started, but not finished, dragging the start piece
    case modificandoCatrina      // Working on the ride
    
    /// Controls whether the mixed reality view containing the ride is visible.
    var isImmersed: Bool {
        switch self {
            case .iniciando, .cargandoArchivos, .esperandoInicar:
                return false
            case .colocandoBaseCatrina, .colocandoEspaciadoCatrina, .modificandoCatrina:
                return true
        }
    }
    
    /// Returns `True` if it's possible to transition to the specified phase from the currrent one.
    func canProgress(to phase: AppEstados) -> Bool {
        switch self {
            case .iniciando:
                return phase == .cargandoArchivos
            case .cargandoArchivos:
                return phase == .esperandoInicar
            case .esperandoInicar:
                return phase == .colocandoBaseCatrina
            case .colocandoBaseCatrina:
                return phase == .colocandoEspaciadoCatrina
            case .colocandoEspaciadoCatrina:
                return [.esperandoInicar, .modificandoCatrina].contains(phase)
            case .modificandoCatrina:
                return [.esperandoInicar].contains(phase)
        }
    }
    
    /// Requests a phase transition.
    @discardableResult
    mutating public func transicion(a estado_nuevo: AppEstados) -> Bool {
        logger.info("Phase change to \(estado_nuevo.rawValue)")
        
        guard self != estado_nuevo else {
            logger.debug("Attempting to change phase to \(estado_nuevo.rawValue) but already in that state. Treating as a no-op.")
            return false
        }
        
        guard canProgress(to: estado_nuevo) else {
            logger.error("Requested transition to \(estado_nuevo.rawValue), but that's not a valid transition.")
            return false
        }
        
        self = estado_nuevo
        return true
    }
  
}
