# BetterRest
In order to output your ideal bedtime, please input your desired wake up time, sleep time, 
and coffee consumption to calculate it using the Core ML implementation.

## Demo
<img src="https://dendev.net/Demos/BetterRest.gif"/>

## Notes
#### Under the hood:
This function allows the app to calculate a bedtime using the SleepCalculator class (CoreML implementation), 
it is then formatted to HH:MM and returned as a String

```swift
    func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let model: SleepCalculator = try SleepCalculator(configuration: .init())
            let prediction = try model.prediction(wake: Double(hour + minute), 
            estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
           
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Please try again..."
        }
    }
```

## Credit
Check out this project at [Hacking with Swift](https://www.hackingwithswift.com/100/swiftui)
