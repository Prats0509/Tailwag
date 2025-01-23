//
//  OurServicesVC.swift
//  TailWag
//


import UIKit

class OurServicesVC: UIViewController {

    
    @IBAction func mainMenuTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMainMenuPage", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
