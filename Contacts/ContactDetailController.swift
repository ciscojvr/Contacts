//
//  ContactDetailController.swift
//  Contacts
//
//  Created by Francisco Ozuna on 3/19/20.
//  Copyright © 2020 Francisco Ozuna. All rights reserved.
//

import UIKit

class ContactDetailController: UITableViewController {
    // we'll always be initializing this TableViewController using init coders, since we're using storyboard to build our layout. Since we won't be able to assign an initial value to the contact stored property during initialization, we have to create an optional property and assign nil to start off. 
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
