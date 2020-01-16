import Accelerate
import Foundation

public final class FFT {
    
    public var bufferFrames: vDSP_Length
    public var halfBufferFrames: vDSP_Length
    public var bufferLog2: vDSP_Length
    private var outReal: [Float]
    private var outImaginary: [Float]
    public var output: DSPSplitComplex
    public var fftSetup: FFTSetup
    public var magnitudes: [Float]
    private var nyquistFrequency: Float
    private var sampleRate: Float
    public var bands: [Band] = []

    
    init(bufferFrames: Int, sampleRate: Float) {
        self.bufferFrames = vDSP_Length(bufferFrames)
        self.halfBufferFrames = vDSP_Length(bufferFrames/2)
        self.bufferLog2 = vDSP_Length(log2f(Float(bufferFrames)))
        self.outReal = [Float](repeating: 0.0, count: bufferFrames/2)
        self.outImaginary = [Float](repeating: 0.0, count: bufferFrames/2)
        self.output = DSPSplitComplex(realp: &outReal, imagp: &outImaginary)
        self.fftSetup = vDSP_create_fftsetup(vDSP_Length(Int(log2f(Float(bufferFrames)))), FFTRadix(kFFTRadix2))!
        self.magnitudes = [Float](repeating: 0.0, count: bufferFrames/2)
        self.nyquistFrequency = sampleRate / 2
        self.sampleRate = sampleRate
    }

    
    /// performs the fast fourier transform on the audio buffer
    ///
    /// - Parameter audioBuffer: Float array representation of the audio buffer
    public func performFFT(audioBuffer: [Float]) {
        
        var tempAudioBuffer = audioBuffer
        let audioBufferPointer: UnsafePointer<DSPComplex>! = tempAudioBuffer.withUnsafeBufferPointer { (ptr) -> UnsafePointer<DSPComplex> in
            return (ptr.baseAddress?.withMemoryRebound(to: DSPComplex.self, capacity: tempAudioBuffer.count, { (ptrAddr) -> UnsafePointer<DSPComplex> in
                return ptrAddr
            }))!
        }
        
        var window = [Float](repeating: 0.0, count: Int(bufferFrames))
        
        vDSP_hann_window(&window, bufferFrames, Int32(vDSP_HANN_NORM))
        
        vDSP_vmul(audioBuffer, 1, window, 1, &tempAudioBuffer, 1, vDSP_Length(audioBuffer.count))
        
        vDSP_ctoz(audioBufferPointer, 2, &output, 1, halfBufferFrames)
        
        vDSP_fft_zrip(fftSetup, &output, 1, bufferLog2, FFTDirection(FFT_FORWARD))
        
        var fftNormFactor: Float = 1.0 / (1 * Float(bufferFrames))

        vDSP_vsmul(output.realp, 1, &fftNormFactor, output.realp, 1, halfBufferFrames);
        vDSP_vsmul(output.imagp, 1, &fftNormFactor, output.imagp, 1, halfBufferFrames);
        
        vDSP_zvmags(&output, 1, &magnitudes, 1, halfBufferFrames)
    }
    
    /// reduces the number of frequency bands by averagin multiple bands in to one band
    ///
    /// - Parameter downto: the number of bands after reduction
    public func reduceBands(downto: Int) {
        
            let numberOfBandsToAverage: Int = Int(round(Double(magnitudes.count / downto)))
            var arrayIndex = 0
            
            bands = [Band](repeating: Band(magnitude: 0, frequency: 0), count: downto)
            
            for i in 0..<downto {
                
                let mean = vDSP_average(array: magnitudes, startIndex: arrayIndex, endIndex: arrayIndex+numberOfBandsToAverage-1)
                bands[i].magnitude = mean
                bands[i].frequency = Float(arrayIndex + numberOfBandsToAverage/2) * (nyquistFrequency/Float(magnitudes.count))
                arrayIndex = arrayIndex+numberOfBandsToAverage
        }
    }
    
    /// calculates the loudest Frequency in the specturm from the fft
    ///
    /// - Returns: a band struct containing the loudest frequency and its magnitude
    public func calculateLoudestFrequency() -> Band {
        
        var index: vDSP_Length = 0
        var magnitude: Float = 0
        
        vDSP_maxvi(&magnitudes, 1, &magnitude, &index, halfBufferFrames)
        
        let frequency = nyquistFrequency/Float(magnitudes.count) * Float(index)
        
        return Band(magnitude: magnitude, frequency: frequency)
    }
    
    
    /// calculates the average Frequency in the specturm from the fft
    ///
    /// - Returns: a band struct which contains the average frequency and the average magnitude
    public func calculateAverageFrequency() -> Band {
        
        var frequencies = magnitudes.enumerated().map({
            (index: Int, element: Float) -> Float in
            return Float(index) * (nyquistFrequency/Float(magnitudes.count))
        })
        
        var length: vDSP_Length = vDSP_Length(magnitudes.count)
        var indexMin: vDSP_Length = 0
        var magnitudeMin: Float = 0
        var indexMax: vDSP_Length = 0
        var magnitudeMax: Float = 0
        
        while magnitudes.count > 2 {
            
            vDSP_minvi(&magnitudes, 1, &magnitudeMin, &indexMin, length)
            vDSP_maxvi(&magnitudes, 1, &magnitudeMax, &indexMax, length)
            
            magnitudes.remove(at: [Int(indexMin), Int(indexMax)])
            frequencies.remove(at: [Int(indexMin), Int(indexMax)])
            length -= 2
        }
        
        if magnitudes.count == 1 {
            
            return Band(magnitude: magnitudes[0], frequency: frequencies[0])
            
        } else {
        
            return Band(magnitude: (magnitudes[0] + magnitudes[1]) / 2, frequency: (frequencies[0] + frequencies[1]) / 2)
        }
    }
    
    public func calculateQuietestFrequency() -> Band {
    
        var index: vDSP_Length = 0
        var magnitude: Float = 0
        
        vDSP_minvi(&magnitudes, 1, &magnitude, &index, halfBufferFrames)
        
        let frequency = nyquistFrequency/Float(magnitudes.count) * Float(index)
        
        return Band(magnitude: magnitude, frequency: frequency)
    }
    
    
    /// averages the fft result using the Accelerate Framework
    ///
    /// - Parameters:
    ///   - array: the array of values to average
    ///   - startIndex: which part of the array to average (first value)
    ///   - endIndex: which part of the array to average (last value)
    /// - Returns: the average value of the array between startIndex and endIndex
    private func vDSP_average(array:[Float], startIndex: Int, endIndex: Int) -> Float {
        var average: Float = 0
        let ptr = UnsafePointer<Float>(array)
        
        vDSP_meanv(ptr + startIndex, 1, &average, vDSP_Length(endIndex - startIndex))
        
        return average
    }
    
    deinit {
        vDSP_destroy_fftsetup(fftSetup)
    }
}

public struct Band {
    var magnitude: Float
    var frequency: Float
    
    init(magnitude: Float, frequency: Float) {
        self.magnitude = magnitude
        self.frequency = frequency
    }
}

extension Array {
    init(repeating: @autoclosure () -> Element, count: Int) {
        self = (0 ..< count).map { _ in repeating() }
    }
    
    mutating func remove(at: [Int]) {
        for index in at.sorted(by: >) {
            remove(at: index)
        }
    }
}
