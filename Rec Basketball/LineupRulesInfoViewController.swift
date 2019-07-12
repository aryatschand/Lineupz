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
        textArray.append("Each player will play all 6 periods")
        textArray.append("If there are no partial players (players playing only 1st or 2nd half), all players must play 5 periods\n\nIf there are partial players, each full player must play either 5 or 6 periods and each partial player must play either 2 or 3 periods")
        textArray.append("If there are no partial players (players playing only 1st or 2nd half), players rated 3.5 or higher must play 4 periods and players rated below 3.5 must play either 4 or 5 periods\n\nIf there are partial players, each full player must play either 4 or 5 periods regardless of rating and each partial player must play either 2 or 3 periods")
        textArray.append("If there are no partial players (players playing only 1st or 2nd half), all players must play either 3 or 4 periods\n\nIf there are partial players, each full player must play either 3 or 4 periods and each partial player must play either 2 or 3 periods")
        textArray.append("If there are no partial players (players playing only 1st or 2nd half), all players must play either 3 or 4 periods\n\nIf there are partial players, each full player must play either 3 or 4 periods and each partial player must play either 2 or 3 periods")
        textArray.append("If there are no partial players (players playing only 1st or 2nd half), all players must play 3 periods\n\nIf there are partial players, each full player must play either 3 or 4 periods and each partial player must play either 2 or 3 periods")
        TextView.text = textArray[number-5]
    }
}
