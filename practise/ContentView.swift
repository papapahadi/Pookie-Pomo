//
//  ContentView.swift
//  practise
//
//  Created by Jatin Singh on 04/08/24.
//

import SwiftUI

extension Color {
    static let chocolate = Color(red: 149/255, green: 69/255, blue: 53/255)
}

class PomodoroModel : ObservableObject {
    @Published var secondsLeft = 25 * 60
    @Published var workSession = true
    @Published var sessionCount = 1
    @Published var totalSession = 6
    var timer : Timer?
    var timeString : String {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        return String(format: "%02d:%02d",minutes,seconds)
    }
    
    var progress : Double {
        let totalSeconds = workSession ? Double(60 * workDuration) : Double(60 * breakDuration)
        let x = totalSeconds - Double(secondsLeft)
        return Double( x / totalSeconds )
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
                self.switchSession()
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
        workSession.toggle()
        if workSession {
            //workSession = false
            secondsLeft = 60 * workDuration
            
        }
        else {
            //workSession = true
            secondsLeft = 60 * breakDuration
            sessionCount += 1
        }
    }
    
}

struct ContentView: View {
    @StateObject var pomodoroModel = PomodoroModel()
    @State private var isSettingPresented = false

    var body: some View {
        NavigationStack {
            ZStack{
                Image(.pomobackground)
                    .resizable()
                    //.frame(height: .infinity)
                    
                Pomodoro(pomodoroModel: pomodoroModel)
                    .padding(35)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 3)
                    //.position(CGPoint(x: 200.0, y: 400.0))
                    .toolbar {
                        ToolbarItem( placement: .topBarTrailing) {
                            Button( ) {
                                isSettingPresented = true
                            } label: {
                                Image(systemName: "gear")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .sheet(isPresented: $isSettingPresented){
                        Settings(pomodoroModel: pomodoroModel)
                    }
            }
            .ignoresSafeArea()
        }
    }
}

struct Settings : View {
    @Environment (\.dismiss) var dismissSheet
    @ObservedObject var pomodoroModel : PomodoroModel
    var body: some View {
        NavigationStack {
            Form {
                //                LinearGradient(colors: [Color.chocolate, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                //                RadialGradient(colors: [.black, .indigo], center: .center, startRadius: 30, endRadius: 80)
                
                    Section {
                        Text("Settings")
                            .font(.custom("headline", size: 34))
                    }
                    //Divider()
                    
                Section(header: Text("Work Duration")
                    .font(.custom("body", size: 15))){
                        Picker("Minutes", selection: $pomodoroModel.workDuration){
                            ForEach(1...60, id: \.self) { minute in
                                Text("\(minute)")
                            }
                        }
                    }
                    
                    Section(header: Text("Break Duration")
                        .font(.custom("body", size: 15))
                    ) {
                        Picker("Break", selection: $pomodoroModel.breakDuration){
                            ForEach(1...60, id: \.self) { second in
                                Text("\(second)")
                            }
                        }
                    }
                
                Section(header: Text("Total Session")
                    .font(.custom("body", size: 15))
                ) {
                    Picker("Session", selection: $pomodoroModel.totalSession){
                        ForEach(1...12, id: \.self) { session in
                            Text("\(session)")
                        }
                    }
                }
                    
                   
                    Section {
                        Button("save") {
                            pomodoroModel.resetTimer()
                            dismissSheet()
                        }
                    }
                
            }
            
        }
    }
}

struct Pomodoro : View {
    @ObservedObject var pomodoroModel : PomodoroModel
    @State private var isPause = true
    let quotes = ["The magic you are looking for is in the work you are avoiding. ", "If You Always Do What You’ve Always Done, You’ll Always Get What You’ve Always Got."]
    var body: some View {
//            LinearGradient(colors: [.pink, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                HStack {
                    
                    Image(systemName: pomodoroModel.workSession ? "brain" : "coffee")
                        .foregroundStyle(Color.chocolate)
                    
                        
                    Text(pomodoroModel.workSession ? "Work Time" : "Break Time")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(pomodoroModel.workSession ? Color.chocolate : .brown)
                        .shadow(radius: 1)
                    //.fill(Color.red.mix(with: .indigo, by: 0.5))
                }
                HStack {
                    Text(pomodoroModel.timeString)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .shadow(radius: 3)
                }
                .padding()
                
                ProgressView(value: pomodoroModel.progress)
                    .containerRelativeFrame(.horizontal){size, axis in
                        return size * 0.6
                    }

                    .padding()
                
                Text("session \(pomodoroModel.sessionCount) of \(pomodoroModel.totalSession)")
                    .foregroundStyle(Color.chocolate)
                    .font(.callout)
                
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
                                .background(LinearGradient(colors: [.red, Color.chocolate], startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        else {
                            Image(systemName: "pause.fill")
                                .padding()
                                .foregroundStyle(.white)
                                .background(LinearGradient(colors: [.red, Color.chocolate], startPoint: .top, endPoint: .bottom))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                
                        }
                        
                    }
                    .padding()
                    
                    Button {
                        pomodoroModel.resetTimer()
                        isPause = true
                    } label: {
                         Image(systemName: "arrow.clockwise")
                            .padding()
                            .background(LinearGradient(colors: [Color.orange, Color.red], startPoint: .top, endPoint: .bottom))
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
                
            }
        
        .ignoresSafeArea()
    }
}



#Preview {
    ContentView(pomodoroModel: PomodoroModel())
        .preferredColorScheme(.light)
        
}
