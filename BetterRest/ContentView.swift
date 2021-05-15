//
//  ContentView.swift
//  BetterRest
//
//  Created by Alex Babou on 5/14/21.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sleep Information:")) {
                    DatePicker("Desired wake up time:", selection: $wakeUp, displayedComponents:
                                .hourAndMinute).font(.headline)
                    HStack {
                        Text("Sleep time:")
                            .font(.headline)
                        Stepper(value: $sleepAmount, in:
                                    4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                    Picker("Amount of coffee in cups:", selection: $coffeeAmount) {
                        ForEach (0 ..< 11) {
                            Text("\($0)")
                        }
                    }.font(.headline)
                }
                Section(header: Text("Your ideal bedtime is:")) {
                    Text("\(calculateBedtime())").font(.system(size: 45, weight: .bold, design: .default))
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let model: SleepCalculator = try SleepCalculator(configuration: .init())
            let prediction = try model.prediction(wake: Double(hour + minute),
                                                  estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Please try again..."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
