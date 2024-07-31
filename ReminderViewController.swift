//
//  ReminderViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-18.
//

import UIKit
import UserNotifications

class ReminderViewController: UIViewController {

    //@IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    var selectedDays: [String] = []
    var reminderTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up date picker
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timePicker.setValue(UIColor.black, forKeyPath: "textColor")
        
        saveButton.layer.cornerRadius = 8
    }
    
    @objc func timeChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        reminderTime = dateFormatter.string(from: timePicker.date)
    }
    
    @IBAction func dayButtonTapped(_ sender: UIButton) {
        guard let day = sender.currentTitle else {
            print("Error: Current title of button is nil")
            return
        }
        
        print("Button tapped for day: \(day)")
        
        if selectedDays.contains(day) {
            // Remove the day from selectedDays
            selectedDays.removeAll { $0 == day }
            sender.backgroundColor = .black
        } else {
            // Add the day to selectedDays
            selectedDays.append(day)
            sender.backgroundColor = .white
        }
    }


    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let reminder = Reminder(days: selectedDays, time: reminderTime)
        scheduleNotifications(for: reminder)
        print("Reminder saved: \(reminder)")
        resetUI()
    }
    
    
    func resetUI() {
        timePicker.date = Date()
        reminderTime = ""
        selectedDays.removeAll()
        for button in [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton] {
            button?.backgroundColor = .white
        }
    }
    
    func scheduleNotifications(for reminder: Reminder) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { [self] granted, error in
            if granted {
                // Schedule notifications
                for day in reminder.days {
                    guard let weekday = self.weekdayNumber(from: day) else { continue }
                    guard let dateComponents = self.dateComponents(for: reminder.time, on: weekday) else { continue }

                    let content = UNMutableNotificationContent()
                    content.title = "Meditation Reminder"
                    content.body = "It's time to meditate!"
                    content.sound = UNNotificationSound.default

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                    let request = UNNotificationRequest(identifier: "\(day)-reminder", content: content, trigger: trigger)
                    center.add(request) { error in
                        if let error = error {
                            print("Error scheduling notification for \(day): \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                print("Notification permission not granted")
            }
        }

    }
    
    func weekdayNumber(from day: String) -> Int? {
        switch day {
        case "SU": return 1
        case "M": return 2
        case "T": return 3
        case "W": return 4
        case "TH": return 5
        case "F": return 6
        case "S": return 7
        default: return nil
        }
    }

    func dateComponents(for time: String, on weekday: Int) -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        guard let date = dateFormatter.date(from: time) else { return nil }

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.weekday = weekday
        return dateComponents
    }
}
