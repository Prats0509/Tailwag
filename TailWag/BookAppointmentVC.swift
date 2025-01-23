//
//  BookAppointmentVC.swift
//  TailWag


import Foundation

import UIKit

class BookAppointmentVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var servicePicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var dogAgeTextField: UITextField!
    @IBOutlet weak var dogWeightTextField: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var healthIssuesTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    let services = ["Grooming", "Health Check", "Vaccination", "Training"]
    let locations = ["Sunnyvale", "Cupertino", "Santa Clara", "Mountain View"]
    let breeds = [
        "Labrador Retriever", "Golden Retriever", "German Shepherd", "Poodle", "Bulldog", "Beagle",
        "Rottweiler", "Dachshund", "Siberian Husky", "Great Dane", "Doberman Pinscher",
        "Boxer", "Shih Tzu", "Chihuahua", "Cocker Spaniel", "Border Collie",
        "Australian Shepherd", "French Bulldog", "Yorkshire Terrier", "Cavalier King Charles Spaniel",
        "Maltese", "Pug", "Bichon Frise", "Alaskan Malamute", "Akita",
        "English Springer Spaniel", "Bernese Mountain Dog", "Weimaraner", "Whippet",
        "Samoyed", "Newfoundland", "Saint Bernard", "Irish Setter", "Jack Russell Terrier",
        "Bull Terrier", "Pointer", "Greyhound", "Papillon", "Shiba Inu"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicePicker.delegate = self
        servicePicker.dataSource = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
      
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == servicePicker {
                return services.count
            } else if pickerView == locationPicker {
                return locations.count
            } else if pickerView == breedPicker {
                return breeds.count
            }
            return 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == servicePicker {
                return services[row]
            } else if pickerView == locationPicker {
                return locations[row]
            } else if pickerView == breedPicker {
                return breeds[row]
            }
            return nil
        }
    
    @IBAction func bookNowButtonTapped(_ sender: UIButton) {
        //DatabaseHelper.shared.clearTable(tableName: "Appointment")
        

        guard let ownerName = ownerNameTextField.text, !ownerName.isEmpty,
                      let phone = phoneNumberTextField.text, !phone.isEmpty,
                      let dogName = dogNameTextField.text, !dogName.isEmpty,
                      let dogAgeText = dogAgeTextField.text, let dogAge = Int(dogAgeText),
                      let dogWeightText = dogWeightTextField.text, let dogWeight = Double(dogWeightText),
                      
                      let selectedBreed = services[safe: servicePicker.selectedRow(inComponent: 0)],
                      let selectedService = services[safe: servicePicker.selectedRow(inComponent: 0)],
                      let selectedLocation = locations[safe: locationPicker.selectedRow(inComponent: 0)] else {
                    showAlert(message: "Please fill all required fields!")
                    return
                }

                let selectedDate = datePicker.date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let formattedDate = formatter.string(from: selectedDate)
                let healthIssues = healthIssuesTextField.text ?? "None"
                let email = emailTextField.text

                DatabaseHelper.shared.insertAppointment(
                    ownerName: ownerName,
                    phoneNumber: phone,
                    email: email,
                    dogName: dogName,
                    breed: selectedBreed,
                    dogAge: dogAge,
                    dogWeight:dogWeight,
                    healthIssues: healthIssues,
                    service: selectedService,
                    location: selectedLocation,
                    appointmentDate: formattedDate
                )

                showAlert(message: "Appointment booked successfully!")
        
        }
    
    @IBAction func analyzeHealthButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showHealthAnalysisSegue", sender: self)

    }
    
    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Submitting...", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    @IBAction func appointmentHistory(_ sender: Any) {
        performSegue(withIdentifier: "showAppointmentHistorySegue", sender: self)
    }
    @IBAction func mainMenuButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMainMenuFromAppointment", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAppointmentHistorySegue" {
            if let destinationVC = segue.destination as? AppointmentsViewer {
                destinationVC.appointments = DatabaseHelper.shared.fetchAppointments()
            }
        }
        
        if segue.identifier == "showHealthAnalysisSegue" {
                if let destinationVC = segue.destination as? DogHealthAnalysisVC {
                    destinationVC.dogName = dogNameTextField.text
                    destinationVC.dogAge = Int(dogAgeTextField.text ?? "0")
                    destinationVC.dogWeight = Double(dogWeightTextField.text ?? "0.0")
                    destinationVC.breed = breeds[safe: breedPicker.selectedRow(inComponent: 0)]
                    destinationVC.healthIssues = healthIssuesTextField.text
                }
            }
    }
    
   
    
}

// MARK: - Safe Array Access Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
    


