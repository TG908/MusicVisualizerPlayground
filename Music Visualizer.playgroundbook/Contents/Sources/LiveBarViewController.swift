import UIKit
import AVFoundation
import SpriteKit
import PlaygroundSupport

public final class LiveBarViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    private var barVisualizerView: SKView!
    private var barVisualizerScene: BarVisualizerScene!
    private var audioEngine = AVAudioEngine()
    private var audioPlayerNode = AVAudioPlayerNode()
    public var audioURL = Bundle.main.url(forResource: "Otis McMusic", withExtension: "m4a")
    private var audioFile = AVAudioFile()
    private var fftBandCount = 6
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBarVisualizerView()
        setupBarVisualizerScene()
        setupAudio()
    }

    
    /// performs the inital setup of the audio engine (select the audio file and installs the tap)
    private func setupAudio() {
        
        audioFile = try! AVAudioFile(forReading: audioURL!)
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        audioEngine.prepare()
        try! audioEngine.start()
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        audioPlayerNode.installTap(onBus: 0, bufferSize: 8192, format: audioFile.processingFormat) { [unowned self] (audioPCMBuffer, audioTime) in
            
            let audioDataLeftChannel = Array(UnsafeBufferPointer(start: audioPCMBuffer.floatChannelData?[0], count:Int(audioPCMBuffer.frameLength)))
            let frames = audioPCMBuffer.frameLength
            let sampleRate = self.audioFile.processingFormat.sampleRate
            
            let fft = FFT(bufferFrames: Int(frames), sampleRate: Float(sampleRate))
                fft.performFFT(audioBuffer: audioDataLeftChannel)
                fft.reduceBands(downto: self.fftBandCount)
                DispatchQueue.main.async {
                    self.barVisualizerScene.updateBands(bands: fft.bands)
            }
        }
        audioPlayerNode.play()
    }
    
    
    /// inital setup of the view containing the scene
    public func setupBarVisualizerView() {
        
        //Create Views
        barVisualizerView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.autoresizesSubviews = true
        view.addSubview(barVisualizerView)
        
        //Setup Constraints
        barVisualizerView.translatesAutoresizingMaskIntoConstraints = false
        barVisualizerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        barVisualizerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        barVisualizerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        barVisualizerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    /// inital setup of the scene contaning the bars
    public func setupBarVisualizerScene() {
        
        //Create Scene
        barVisualizerScene = BarVisualizerScene(size: CGSize(width: barVisualizerView.frame.width, height: barVisualizerView.frame.height))
        barVisualizerScene.scaleMode = .resizeFill
        barVisualizerView.presentScene(barVisualizerScene)
    }
    
    
    /// creates the bars visualizing a certain frequency range and its average magnitude
    ///
    /// - Parameters:
    ///   - numberOfBars: number of bars to display
    ///   - width: wiht of one single bar
    ///   - spacing: spacing between all the bars
    ///   - color: color of the bars
    public func createBars(numberOfBars: Int, width: CGFloat, spacing: CGFloat, color: UIColor) {
        fftBandCount = numberOfBars
        barVisualizerScene.layoutBars(numberOfBars: numberOfBars, width: width, spacing: spacing, color: color)
    }
}
