//
//  LineupRulesInfoViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/8/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit

class LineupRulesInfoViewController: UIViewController {

    var gameIndex: Int = 0
    var team: Team!
    var teamArray = [Team]()
    var number: Int = 0
    var textArray: [String] = []
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var TextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // When page is loaded, display the rules for the specific number of playerys playing
    override func viewWillAppear(_ animated: Bool) {
        NavigationItem.title = "\(number) Players"
        textArray.append("1) Everyone Plays the entire Game")
        textArray.append("1) Everyone will sit 1 full segment\n\n2) Everyone will play 35 minutes")
        textArray.append("1) Everyone must sit at least 1 full segment\n\n2) 2 players will play 35 minutes\n\n3) 5 Players will play 28 minutes")
        textArray.append("1) Everyone Must play at least 1 segment each half and sit at least 2 full segment\n\n2) 6 Players will play 28 minutes\n\n3) 2 Players will play 21 minutes")
        textArray.append("1) Everyone must play at least 1 segment each half and sit at least 2 full segments\n\n2) 3 Players will play 28 minutes\n\n3) 6 Players will play 21 minutes")
        textArray.append("1) Everyone must play at least 1 segment each half and sit 3 full segments\n\n2) All Players will play 21 minutes")
        TextView.text = textArray[number-5]
    }
}
