//
//  MainMenuFooter.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 02/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
//

import Foundation
import UIKit

class MainMenuFooter: UITableViewHeaderFooterView {
    let title = UILabel()
    let homeButton = UIButton()
    let forecastButton = UIButton()
    let mapButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        contentView.addSubview(homeButton)
        contentView.addSubview(forecastButton)
        contentView.addSubview(mapButton)

       
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            forecastButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 30),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
