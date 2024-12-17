//
//  NotesView.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 16/12/24.
//



import SwiftUI
import Speech
import AVFoundation

struct NotesModal: View {
    let item: String
    @Binding var notes: [String: String] // Notes dictionary
    @State private var noteText: String = "" // Text for the notes
    @State private var isRecording = false   // State to track recording status
    @Environment(\.dismiss) var dismiss // For dismissing the modal

    // Speech Recognizer Properties
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?

    var body: some View {
        NavigationView {
            VStack {
                Text("Notes for \(item)")
                    .font(.headline)
                    .padding()

                // Text Editor for Notes
                TextEditor(text: $noteText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(height: 200)

                Spacer()

                // Speech-to-Text Microphone Button
                Button(action: {
                    toggleRecording()
                }) {
                    Image(systemName: isRecording ? "mic.fill" : "mic.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(isRecording ? .red : .blue)
                        .padding()
                }

                // Save Button
                Button(action: {
                    notes[item] = noteText // Save the note text
                    dismiss()
                }) {
                    Text("Save Notes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .onAppear {
                // Load existing notes if available
                noteText = notes[item] ?? ""
                requestSpeechAuthorization()
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }

    // MARK: - Speech Recognition Functions

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                if status != .authorized {
                    print("Speech recognition not authorized.")
                    // Handle the case when permission is denied
                }
            }
        }
    }

    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        // Check if speech recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }

        isRecording = true
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        // Ensure recognition request is not nil
        guard let recognitionRequest = recognitionRequest else {
            print("Recognition request is nil.")
            return
        }

        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                // Update noteText with the transcribed speech
                noteText = result.bestTranscription.formattedString
            }

            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }

        // Configure audio input
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine couldn't start: \(error.localizedDescription)")
            stopRecording()
        }
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
    }
}
