import SwiftUI
import Combine
import Speech
import AVFoundation

enum SearchState {
    case idle
    case listening
    case processing
    case results
}

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var state: SearchState = .idle
    @Published var isListening: Bool = false
    @Published var audioLevel: CGFloat = 0
    @Published var suggestions: [String] = []
    
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    init() {
        setupDefaultSuggestions()
    }
    
    private func setupDefaultSuggestions() {
        suggestions = [
            "Organize my downloads folder",
            "Rename screenshots from today",
            "Find large files on desktop",
            "Create a new folder structure"
        ]
    }
    
    func submitSearch() {
        guard !searchText.isEmpty else { return }
        
        state = .processing
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.state = .results
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.reset()
            }
        }
    }
    
    func startListening() {
        guard !isListening else { return }
        
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                guard status == .authorized else { return }
                self?.beginRecording()
            }
        }
    }
    
    private func beginRecording() {
        isListening = true
        state = .listening
        
        audioEngine = AVAudioEngine()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let audioEngine = audioEngine,
              let recognitionRequest = recognitionRequest,
              let speechRecognizer = speechRecognizer else {
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
            
            let level = self?.calculateAudioLevel(buffer: buffer) ?? 0
            DispatchQueue.main.async {
                self?.audioLevel = level
            }
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self?.searchText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil || (result?.isFinal ?? false) {
                DispatchQueue.main.async {
                    self?.stopListening()
                }
            }
        }
    }
    
    private func calculateAudioLevel(buffer: AVAudioPCMBuffer) -> CGFloat {
        guard let channelData = buffer.floatChannelData?[0] else { return 0 }
        let frameLength = Int(buffer.frameLength)
        
        var sum: Float = 0
        for i in 0..<frameLength {
            sum += abs(channelData[i])
        }
        
        let average = sum / Float(frameLength)
        return CGFloat(min(average * 10, 1.0))
    }
    
    func stopListening() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        audioEngine = nil
        recognitionRequest = nil
        recognitionTask = nil
        
        isListening = false
        state = searchText.isEmpty ? .idle : .results
        audioLevel = 0
    }
    
    func reset() {
        searchText = ""
        state = .idle
        isListening = false
        audioLevel = 0
    }
}
