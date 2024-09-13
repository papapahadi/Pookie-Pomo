//
//  ContentView.swift
//  practise
//
//  Created by Jatin Singh on 04/08/24.
//

import SwiftUI

class PomodoroModel : ObservableObject {
    @Published var secondsLeft = 25 * 60
    var timer : Timer?
    var timeString : String {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        return String(format: "%02d:%02d",minutes,seconds)
    }
    @Published var workDuration = 25
    @Published var breakDuration = 5
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.secondsLeft > 0 {
                self.secondsLeft -= 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        secondsLeft = workDuration * 60
    }
    
}

struct ContentView: View {
    @StateObject var pomodoroModel = PomodoroModel()
    var body: some View {
        Pomodoro(pomodoroModel: pomodoroModel)
    }
}

struct Settings : View {
    @ObservedObject var pomodoroModel : PomodoroModel
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Minutes", selection: $pomodoroModel.workDuration){
                        ForEach(1...60, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                }
                Section {
                    Picker("Break", selection: $pomodoroModel.breakDuration){
                        
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct Pomodoro : View {
    @ObservedObject var pomodoroModel : PomodoroModel
    @State private var pause = false
    @State private var isSettingPresented = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                
                HStack {
                    Text(pomodoroModel.timeString)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                }
                .padding()
                Button{
                    if !pause { pomodoroModel.startTimer() }
                    else { pomodoroModel.stopTimer() }
                    pause.toggle()
                    
                } label : {
                    if !pause {
                        Image(systemName: "play.fill")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.red)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "pause.fill")
                            .padding()
                            .foregroundStyle(.white)
                            .background(.red)
                            .clipShape(Circle())
                    }
                    
                }
    
            }
        }
        .toolbar {
            Button("Settings", action: {isSettingPresented.toggle()})
        }
        .ignoresSafeArea()
    }
}



#Preview {
    ContentView(pomodoroModel: PomodoroModel())
}
