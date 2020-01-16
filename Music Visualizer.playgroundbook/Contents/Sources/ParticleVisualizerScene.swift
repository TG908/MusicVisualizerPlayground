import SpriteKit
import Foundation

public final class ParticleVisualizerScene: SKScene {
    
    
    /// updates one particle with the data from a band struct
    ///
    /// - Parameters:
    ///   - band: contains frequency and magnitude values used for visualization
    ///   - particle: particle to apply the data on
    public func updateParticlePosition(band: Band, particle: SKEmitterNode) {
        
        let verticalScalingFactor = Float(frame.height/(log2(100000 * 140 + 1)))
        let horizontalScalingFactor = Float(frame.width/(log2(0.1 * 1000 + 1)))
        
        if particle.name == "createdFromFile" {
            //How it should work
            let updateNodePosition = SKAction.move(to: CGPoint(x: CGFloat(log2(0.1 * band.frequency.truncatingRemainder(dividingBy: 1000) + 1) * horizontalScalingFactor), y: CGFloat(log2(100000 * band.magnitude + 1) * verticalScalingFactor)), duration: 0.5)
            particle.run(updateNodePosition)
        } else {
            //Hack to make up for the difference in behaviour by SKEmitterNodes not created from a file by modifying the duration
            let updateNodePosition = SKAction.move(to: CGPoint(x:  CGFloat(log2(0.1 * band.frequency.truncatingRemainder(dividingBy: 1000) + 1) * horizontalScalingFactor), y: CGFloat(log2(100000 * band.magnitude + 1) * verticalScalingFactor)), duration: 10.0)
            particle.run(updateNodePosition)
        }
    }
    
    
    /// adds a new particle system to the scene
    ///
    /// - Parameter particleSystem: the particle system to add to the scene
    public func addParticleSystem(particleSystem: SKEmitterNode) {
        //particleNodes.append(particleSystem)
        anchorPoint = CGPoint(x: 0.0, y: 0.1)
        particleSystem.position = CGPoint(x: 0, y:0)
        particleSystem.targetNode = self
        addChild(particleSystem)
    }
}
