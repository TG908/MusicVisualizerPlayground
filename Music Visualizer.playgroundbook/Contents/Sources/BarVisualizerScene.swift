import SpriteKit

public final class BarVisualizerScene: SKScene {

    private var bars: [SKSpriteNode] = []
    private var numberOfBars = 0
    private var barWidth: CGFloat = 0
    private var barSpacing: CGFloat = 0
    private var barColor: UIColor = .green

    
    public override func didChangeSize(_ oldSize: CGSize) {
        layoutBars(numberOfBars: numberOfBars, width: barWidth, spacing: barSpacing, color: barColor)
    }
    
    /// positions the bars in the scene
    ///
    /// - Parameters:
    ///   - numberOfBars: number of bars to be displayed
    ///   - width: width of one single bar
    ///   - spacing: spacing between all the bars
    ///   - color: color of the bar
    public func layoutBars(numberOfBars: Int, width: CGFloat, spacing: CGFloat, color: UIColor) {
        removeAllBars()
        
        self.numberOfBars = numberOfBars
        self.barWidth = width
        self.barSpacing = spacing
        self.barColor = color
        
        let overallWidth = CGFloat(numberOfBars) * (width+spacing)
        let leftSpacer = overallWidth < frame.width ? (frame.width - overallWidth) / 2 : width/2
        
        for i in 0..<numberOfBars {
            let node = SKSpriteNode(color: color, size: CGSize(width: width, height: 60))
            node.position = CGPoint(x: leftSpacer + CGFloat(i) * (width+spacing), y: 0)
            bars.append(node)
            addChild(node)
        }
    }
    
    /// removes all bars from the model and the scene
    private func removeAllBars() {
        for bar in bars {
            bar.removeFromParent()
        }
        bars = []
    }
    
    
    /// updates the properties of all the bars with data from the Band Array
    ///
    /// - Parameter bands: contains the freqency and magnitude values for each bar
    public func updateBands(bands: [Band]) {
        for i in 0..<bars.count {
            let updateBarHeight = SKAction.resize(toHeight: CGFloat(sqrt(bands[i].magnitude * 100000000) * 10), duration: 0.2)
            bars[i].run(updateBarHeight)
        }
    }
}
