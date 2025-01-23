//
//  AppointmentsViewer.swift
//  TailWag
//

import UIKit

class AppointmentsViewer: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!

    
    var appointments: [[String: Any]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        appointments = DatabaseHelper.shared.fetchAppointments()
        tableView.reloadData()
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointments.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No Appointments Found"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return appointments.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath)
        let appointment = appointments[indexPath.row]

        print("Configuring cell for appointment: \(appointment)")


        let dogName = appointment["dogName"] as? String ?? "Unknown Dog"
        let service = appointment["service"] as? String ?? "Unknown Service"
        let date = appointment["appointmentDate"] as? String ?? "No Date Available"

        
        cell.textLabel?.text = "\(dogName) - \(service) - Date: \(date)"
        cell.detailTextLabel?.text = "Date: \(date)"
        return cell
    }
    @IBAction func mainMenuTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMainMenuFromHistory", sender: self)
    }
}
