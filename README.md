# Pomodoro iOS App

A simple and customizable Pomodoro timer app built using SwiftUI, designed to help you stay productive by alternating between focused work sessions and short breaks.

## Features

- **Customizable Timers**: Set your own work duration, break duration, and the total number of sessions.
- **Progress Tracking**: Visual progress bar to track the current session.
- **Session Counter**: Keep track of how many sessions you've completed.
- **Start, Pause, and Reset**: Simple controls for managing your Pomodoro sessions.
- **Elegant UI**: Clean and modern design with smooth animations.

## Screenshots



## How to Use

1. **Start a Session**: Press the play button to start the timer.
2. **Pause the Timer**: Pause the timer anytime by pressing the pause button.
3. **Reset the Timer**: Press the reset button to start a new session from the beginning.
4. **Settings**: Adjust the work duration, break duration, and total number of sessions through the settings menu.

## Customization Options

- **Work Duration**: Choose between 1 to 60 minutes.
- **Break Duration**: Set breaks from 1 to 60 minutes.
- **Total Sessions**: Adjust the number of Pomodoro sessions from 1 to 12.

## Getting Started

### Prerequisites

- Xcode 14 or later
- iOS 16.0 or later

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/pomodoro-ios-app.git
    ```
2. Open the project in Xcode:
    ```bash
    cd pomodoro-ios-app
    open Pomodoro.xcodeproj
    ```
3. Run the app on your simulator or physical device.

## Code Overview

The app is built using SwiftUI and leverages the `ObservableObject` pattern to manage the Pomodoro timer state. Here's a breakdown of the key components:

- **PomodoroModel**: The core logic for handling the timer, switching between work and break sessions, and managing the session count.
- **ContentView**: The main UI view that displays the timer, session details, and buttons to start/pause/reset.
- **Settings View**: Allows users to configure work/break durations and the total number of sessions.
- **Pomodoro View**: Displays the timer, progress bar, and controls.

## Future Enhancements

- **Notifications**: Add push notifications to alert the user when a session or break is complete.
- **Dark Mode Support**: Improve UI for dark mode compatibility.
- **Statistics**: Track and display user productivity over time.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to adjust any specific details like links or add sections like screenshots depending on your project.
