//
//  ContentView.swift
//  practise
//
//  Created by Jatin Singh on 04/08/24.
//

import SwiftUI

class PomodoroModel : ObservableObject {
    @Published var secondsLeft = 25 * 60
    @Published var workSession = true
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
            else {
                switchSession()
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
    
    func switchSession() {
        if workSession {
            workSession = false
        }
        else {
            workSession = true
        }
    }
    
}

struct ContentView: View {
    @StateObject var pomodoroModel = PomodoroModel()
    @State private var isSettingPresented = false

    var body: some View {
        NavigationStack {
            Pomodoro(pomodoroModel: pomodoroModel)
                .toolbar {
                    Button {
                        isSettingPresented = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isSettingPresented){
                    Settings(pomodoroModel: pomodoroModel)
                }
        }
    }
}

struct Settings : View {
    @Environment (\.dismiss) var dismissSheet
    @ObservedObject var pomodoroModel : PomodoroModel
    var body: some View {
        NavigationStack {
            
            ZStack {
                LinearGradient(colors: [.white, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack {
                    Spacer()
                    Section {
                        Text("Settings")
                            .font(.headline)
                    }
                    Spacer()
                    Section(header: Text("Work Duration")) {
                        Picker("Minutes", selection: $pomodoroModel.workDuration){
                            ForEach(1...60, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                    }
        
                    Section(header: Text("Break Duration")) {
                        Picker("Break", selection: $pomodoroModel.breakDuration){
                            ForEach(1...60, id: \.self) { second in
                                Text("\(second)")
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    Section {
                        Button("save") {
                            pomodoroModel.resetTimer()
                            dismissSheet()
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom))
                        .clipShape(.rect(cornerRadius: 29))
                        .shadow(radius: 3)
                    }
                    Spacer()
                }
                
            }
                
            
        }
    }
}

struct Pomodoro : View {
    @ObservedObject var pomodoroModel : PomodoroModel
    @State private var isPause = true
    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Text(pomodoroModel.workSession ? "Work Time" : "Break TIme")
                    .font(.largeTitle.bold())
                    .foregroundStyle(pomodoroModel.workSession ? .red : .green)
                
                HStack {
                    Text(pomodoroModel.timeString)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                }
                .padding()
                HStack {
                    Button{
                        if isPause { pomodoroModel.startTimer() }
                        else { pomodoroModel.stopTimer() }
                        isPause.toggle()
                        
                    } label : {
                        if isPause {
                            Image(systemName: "play.fill")
                                .padding()
                                .foregroundStyle(.white)
                                .background(LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())
                        }
                        else {
                            Image(systemName: "pause.fill")
                                .padding()
                                .foregroundStyle(.white)
                                .background(LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())
                                
                        }
                        
                    }
                    .padding()
                    
                    Button {
                        pomodoroModel.resetTimer()
                        isPause = true
                    } label: {
                         Image(systemName: "arrow.clockwise")
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
    
            }
        }
        .ignoresSafeArea()
    }
}



#Preview {
    ContentView(pomodoroModel: PomodoroModel())
}
