//
//  ViewController.swift
//  TailWag
//


import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlayer: AVAudioPlayer?

    @IBAction func bookAppointmentButtonTapped(_ sender: UIButton) {
        playSound(named: "button_click")
        performSegue(withIdentifier: "goToAppointmentPage", sender: self)
    }
    
    @IBAction func contactUsTapped(_ sender: UIButton) {
        playSound(named: "button_click")
        performSegue(withIdentifier: "goToContactUs", sender: self)

    }
    @IBAction func appointmentHistoryTapped(_ sender: UIButton) {
        playSound(named: "button_click")
        performSegue(withIdentifier: "goToAppointmentHistory", sender: self)

    }
    @IBAction func ourServicesTapped(_ sender: UIButton) {
        playSound(named: "button_click")
        performSegue(withIdentifier: "goToOurServices", sender: self)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(named: "button_click")
        // Do any additional setup after loading the view.
    }

    private func playSound(named soundName: String) {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
                print("Sound file \(soundName) not found")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Failed to play sound \(soundName): \(error.localizedDescription)")
            }
        }
}

