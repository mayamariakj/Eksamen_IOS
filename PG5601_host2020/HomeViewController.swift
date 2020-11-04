//
//  homeViewController.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 04/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import UIKit
import Foundation


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTable: UITableView!
    
     let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.homeTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
       self.homeTable.delegate = self
       self.homeTable.dataSource = self
       
       self.homeTable.rowHeight = 100
       self.homeTable.sectionHeaderHeight = 75
       
       self.homeTable.register(MainMenuHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        
        switch indexPath.row {
        case 0:
            cell.homeLabel.text = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        case 1:
            cell.homeLabel.text = "bilde"
        case 2:
            cell.homeLabel.text = "paraply"
                            
        default:
            print("\(indexPath.row ) line not found")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = self.homeTable.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as! MainMenuHeader
        view.title.text = "Home"
       // view.subtitle.text = myLocationName

       return view
    }
    
}
