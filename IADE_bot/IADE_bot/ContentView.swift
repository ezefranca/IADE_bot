//
//  ContentView.swift
//  IADE_bot
//
//  Created by Ezequiel dos Santos on 09/02/2024.
//

import SwiftUI
import SwiftWhisper

struct ContentView: View {
    
    var viewModel = ViewModel()
    var body: some View {
        VStack {
            RecordView(viewModel: viewModel)
        }
        .padding()
    }
    
    func test() async {
        guard let modelURL = Bundle.main.url(forResource: "ggml-model-whisper-medium-q5_0", withExtension: "bin") else {
            print("Model file not found in app bundle.")
            return
        }
        
        let whisper = Whisper(fromFileURL: modelURL, withParams: .default)
        let segments = try! await whisper.transcribe(audioFrames: [1.0, 2.0, 3.0])
        
        print("Transcribed audio:", segments.map(\.text).joined())
    }
}

#Preview {
    ContentView()
}
