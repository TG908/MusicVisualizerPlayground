import UIKit
import AVFoundation
import SpriteKit
import PlaygroundSupport

public final class LiveParticleViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    private var particleVisualizerView: SKView!
    private var particleVisualizerScene: ParticleVisualizerScene!
    private var audioEngine = AVAudioEngine()
    private var audioPlayerNode = AVAudioPlayerNode()
    private var audioFile = AVAudioFile()
    private var particleSystems : [ParticleSystem] = []
    private var audioLeft: Audio = Audio()
    private var audioRight: Audio = Audio()
    public var audioURL = Bundle.main.url(forResource: "HyperParadise", withExtension: "m4a")
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
        setupParticleVisualizerView()
        setupParticleVisualizerScene()
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
            
            let frames = Int(audioPCMBuffer.frameLength)
            let sampleRate = Float(self.audioFile.processingFormat.sampleRate)
            
            for particleSystem in self.particleSystems {
                
                self.particleVisualizerScene.updateParticlePosition(band: particleSystem.bandFunc(particleSystem.frequencySource, particleSystem.frequencyType, audioPCMBuffer, frames, sampleRate), particle: particleSystem.particle)
            }
        }
        audioPlayerNode.play()
    }
    
    
    /// performs a fft on the audio buffer for a certain audio channel and also calculates the average frequency or the max frequency of the spectrum
    ///
    /// - Parameters:
    ///   - source: the audio source either leftChannel or rightChannel
    ///   - type: the frequency to calculate either maxFrequency or averageFrequency
    ///   - audioBuffer: the audio buffer to perform the fft on
    ///   - frameCount: needed for the fft calculation
    ///   - sampleRate: needed for the frequency calculation
    /// - Returns: a band struct containing the result for desired frequencySource and frequencyType
    private func performFFT(source: FrequencySource, type: FrequecyType, audioBuffer: AVAudioPCMBuffer, frameCount: Int, sampleRate: Float) -> Band {
        
        let fft = FFT(bufferFrames: frameCount, sampleRate: sampleRate)
        var audioData: [Float] = []
        
        switch source {
            
        case .leftChannel:
            audioData = Array(UnsafeBufferPointer(start: audioBuffer.floatChannelData![0], count:Int(audioBuffer.frameLength)))
            break
            
        case .rightChannel:
            audioData = Array(UnsafeBufferPointer(start: audioBuffer.floatChannelData![1], count:Int(audioBuffer.frameLength)))
            break
        }
        
        fft.performFFT(audioBuffer: audioData)

        switch type {
            
        case .averageFrequency:
            return fft.calculateAverageFrequency()
            
        case .loudestFrequency:
            return fft.calculateLoudestFrequency()
            
        case .quietestFrequency:
            return fft.calculateQuietestFrequency()
        }
    }
    
    /// adds a particle system to the scene
    ///
    /// - Parameters:
    ///   - forSource: source of audio to visualize
    ///   - withType: the frequency used for the visualization either maxFrequency or averageFrequency
    ///   - particle: the particle used for the visualization
    public func addParticleSystem(forSource: FrequencySource, withType: FrequecyType, particle: SKEmitterNode) {
        
        let particleSystem = ParticleSystem(particle: particle, frequencySource: forSource, frequencyType: withType, bandFunc: performFFT)
            particleSystems.append(particleSystem)
        
            particleVisualizerScene.addParticleSystem(particleSystem: particleSystem.particle)
    }
    
    /// inital setup of the view containing the scene
    private func setupParticleVisualizerView() {
        
        //Create Views
        particleVisualizerView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(particleVisualizerView)
        
        //Setup Constraints
        particleVisualizerView.translatesAutoresizingMaskIntoConstraints = false
        particleVisualizerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        particleVisualizerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        particleVisualizerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        particleVisualizerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /// inital setup of the scene contaning the particle visualizer
    private func setupParticleVisualizerScene() {
        
        //Create Scene
        particleVisualizerScene = ParticleVisualizerScene(size: CGSize(width: particleVisualizerView.frame.width, height: particleVisualizerView.frame.height))
        particleVisualizerScene.scaleMode =  .resizeFill
        particleVisualizerView.presentScene(particleVisualizerScene)
    }
}

public struct ParticleSystem {
    var particle: SKEmitterNode
    var frequencySource: FrequencySource
    var frequencyType: FrequecyType
    var bandFunc: (FrequencySource, FrequecyType, AVAudioPCMBuffer, Int, Float) -> (Band)
    
    init(particle: SKEmitterNode, frequencySource: FrequencySource, frequencyType: FrequecyType, bandFunc: @escaping (FrequencySource, FrequecyType, AVAudioPCMBuffer, Int, Float) -> (Band)) {
        self.particle = particle
        self.frequencySource = frequencySource
        self.frequencyType = frequencyType
        self.bandFunc = bandFunc
    }
}

public struct Audio {
    var averageFrequency: Band = Band(magnitude: 0, frequency: 0)
    var loudestFrequency: Band = Band(magnitude: 0, frequency: 0)
}

public enum FrequencySource {
    case leftChannel
    case rightChannel
}

public enum FrequecyType {
    case averageFrequency
    case loudestFrequency
    case quietestFrequency
}
