//
//  LineupDetailsViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 10/12/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit

class LineupDetailsViewController: UIViewController, UITextFieldDelegate {
    
    var gameIndex: Int = 0
    var team: Team!
    var teamArray = [Team]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")

    @IBOutlet weak var NameField: UITextField!
    
    @IBOutlet weak var DetailsField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savebtn(_ sender: Any) {
        if NameField.text! != "" {
        team.gameList[gameIndex].name = NameField.text!
        team.gameList[gameIndex].details = DetailsField.text!
        saveGame()
        navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Empty Name", message: "Please enter a name for the lineup.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            })
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NameField.text = team.gameList[gameIndex].name
        DetailsField.text = team.gameList[gameIndex].details
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveGame() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(teamArray)
            try data.write(to: dataFilePath!)
        } catch {
            let alert = UIAlertController(title: "Error Code 23", message: "Something went wrong! Please reload App.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

}
