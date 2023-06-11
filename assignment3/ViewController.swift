import UIKit

class ViewController: UIViewController {

    var clockLabel = UILabel()
    var timerLabel = UILabel()
    var timer: Timer?
    var countDownTimer: Timer?
    var countDownTime: TimeInterval = 0
    var datePicker = UIDatePicker()
    var startStopButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI elements
        setupUI()
        
        // Start the clock
        startClock()
    }
    
    func setupUI() {
        // Setup clock label
        clockLabel.frame = CGRect(x: 20, y: 80, width: self.view.frame.size.width - 40, height: 30)
        self.view.addSubview(clockLabel)

        // Setup date picker
        datePicker.frame = CGRect(x: 20, y: 120, width: self.view.frame.size.width - 40, height: 200)
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        self.view.addSubview(datePicker)

        // Setup timer label
        timerLabel.frame = CGRect(x: 20, y: 330, width: self.view.frame.size.width - 40, height: 30)
        timerLabel.text = "00:00:00"
        self.view.addSubview(timerLabel)

        // Setup start/stop button
        startStopButton.frame = CGRect(x: 20, y: 370, width: self.view.frame.size.width - 40, height: 50)
        startStopButton.setTitle("Start Timer", for: .normal)
        startStopButton.setTitleColor(UIColor.blue, for: .normal)
        startStopButton.addTarget(self, action: #selector(startStopButtonPressed), for: .touchUpInside)
        self.view.addSubview(startStopButton)
    }
    
    func startClock() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
            self.clockLabel.text = formatter.string(from: now)

            // Change background color
            let hour = Calendar.current.component(.hour, from: now)
            self.view.backgroundColor = (6...18).contains(hour) ? UIColor.lightGray : UIColor.darkGray
        }
    }
    
    @objc func startStopButtonPressed() {
        if startStopButton.titleLabel?.text == "Start Timer" {
            startStopButton.setTitle("Stop Timer", for: .normal)
            datePicker.isEnabled = false
            
            // Set count down time based on datePicker
            countDownTime = datePicker.countDownDuration
            
            // Start countdown timer
            countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.countDownTime > 0 {
                    self.countDownTime -= 1
                    let hour = Int(self.countDownTime) / 3600
                    let minute = Int(self.countDownTime) / 60 % 60
                    let second = Int(self.countDownTime) % 60
                    
                    self.timerLabel.text = String(format: "%02i:%02i:%02i", hour, minute, second)
                } else {
                    self.resetTimer()
                }
            }
        } else {
            resetTimer()
        }
    }
    
    func resetTimer() {
        startStopButton.setTitle("Start Timer", for: .normal)
        datePicker.isEnabled = true
        countDownTimer?.invalidate()
        timerLabel.text = "00:00:00"
    }
}

