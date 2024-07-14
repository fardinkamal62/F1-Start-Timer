//
//  ContentView.swift
//  F1 Start Timer
//
//  Created by Fardin Kamal on 12/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var time: Double = 0.000
    @State private var runTimer = false
    @State private var timer: Timer?
    @State private var startTime: Double = 0.0
    @State private var endTime: Double = 0.0
    @State private var timeDifference: Double = 0.0
    @State private var isStartTimeout = false
    @State private var jumpStartMessage: String = ""
    
    @StateObject private var sharedProperties = SharedProperties()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationView {
            HistoryPage()
            VStack{
                ZStack{
                    VStack(alignment: .center    , spacing: 0){
                        Text("F1 Start Timer")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .fontDesign(.serif)
                        Text("Test your reaction time")
                            .font(.title2)
                            .fontDesign(.serif)
                        
                        TimerLights()
                        
                        Text("Tap/click when you're ready to race, then tap again when the lights go out.")
                            .fontWeight(.bold)
                            .fontDesign(.serif)
                        
                        if (jumpStartMessage != "") {
                            Text(jumpStartMessage)
                                .font(.system(size: 200))
                                .foregroundColor(Color.red)
                        } else{
                            Text(String(format: "%.3f", time))
                                .font(.system(size: 150))
                        }
                    }
#if os(macOS)
                    LeftClickView(onLeftClick: {
                        timeInit()
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
#endif
#if os(iOS)
                    Rectangle()
                        .fill(Color.white.opacity(0.000000001))
                    
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .gesture(TapGesture()
                            .onEnded{ timeInit() }
                        )
#endif
                }
            }
            .environmentObject(sharedProperties)
        }
    }
    
    private func addItem(time: Double) {
        withAnimation {
            let newItem = Item(timestamp: Date(), time: time)
            modelContext.insert(newItem)
        }
    }
    
    private func startTimer() {
        startTime = Date().timeIntervalSince1970
    }
    
    private func stopTimer() {
        endTime = Date().timeIntervalSince1970
    }
    
    private func reset() {
        stopTimer()
        startTime = 0.0
        endTime = 0.0
        sharedProperties.changeColor(color: "red")
        isStartTimeout = false
        runTimer = false
    }
    
    private func timeInit() {
        if isStartTimeout {
            jumpStartMessage = "Jump Start!"
            time = 9999.99999
            reset()
            return
        }
        jumpStartMessage = ""
        
        time = 0.000
        runTimer.toggle()
        
        let randomSeconds = Int.random(in: 1..<5)
        let randomMiliseconds = Int.random(in: 0..<10)
        
        if runTimer {
            isStartTimeout.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(randomSeconds) + .milliseconds(randomMiliseconds), execute: {
                isStartTimeout.toggle()
                if isStartTimeout {
                    jumpStartMessage = "Jump Start!"
                    time = 9999.99999
                    reset()
                    return
                }
                sharedProperties.changeColor(color: "gray")
                
                startTimer()
            })
            
        } else {
            stopTimer()
            timeDifference = endTime - startTime
            time = timeDifference
            addItem(time: time)
            
            reset()
        }
    }
#if os(macOS)
    // Left click handler
    class LeftClickableView: NSView {
        var onLeftClick: (() -> Void)?
        
        override func mouseDown(with theEvent: NSEvent) {
            if theEvent.buttonNumber == 0 { // Check for left mouse button
                onLeftClick?()
            }
        }
    }
    
    struct LeftClickView: NSViewRepresentable {
        var onLeftClick: (() -> Void)?
        
        func makeNSView(context: Context) -> LeftClickableView {
            let view = LeftClickableView()
            view.onLeftClick = onLeftClick
            return view
        }
        
        func updateNSView(_ nsView: LeftClickableView, context: Context) {
            // No need for update in this case
        }
    }
    //
#endif
}

public class SharedProperties: ObservableObject {
    @Published public var countdownLightColor = Color.red
    
    public init() {}
    
    func changeColor(color: String) {
        let colorMap: [String: Color] = [
            "red": .red,
            "gray": .gray
        ]
        
        if let newColor = colorMap[color.lowercased()] {
            countdownLightColor = newColor
        } else {
            print("Color not found. Defaulting to red.")
            countdownLightColor = .red
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
