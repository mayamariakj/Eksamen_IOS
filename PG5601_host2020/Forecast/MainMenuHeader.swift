//
//  MainMenuHeader.swift
//  PG5601_host2020
//
//  Created by Maya maria Kjær on 02/11/2020.
//  Copyright © 2020 Maya maria Kjær. All rights reserved.
// swift documentation

import Foundation
import UIKit

class MainMenuHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let subtitle = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        contentView.addSubview(subtitle)


       
        NSLayoutConstraint.activate([
           
            title.heightAnchor.constraint(equalToConstant: 30),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitle.heightAnchor.constraint(equalToConstant: 30),
            subtitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor)

        ])
    }
}
