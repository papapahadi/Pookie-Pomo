//
//  practiseApp.swift
//  practise
//
//  Created by Jatin Singh on 04/08/24.
//

import SwiftUI

@main
struct practiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(pomodoroModel: PomodoroModel())
        }
    }
}
