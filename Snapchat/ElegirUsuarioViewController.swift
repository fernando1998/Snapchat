//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 23/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
