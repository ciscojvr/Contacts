//
//  ContactListController.swift
//  Contacts
//
//  Created by Francisco Ozuna on 3/19/20.
//  Copyright © 2020 Francisco Ozuna. All rights reserved.
//

import UIKit

class ContactListController: UITableViewController {
    
    var contacts = ContactsSource.contacts

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        // since all rows are going to be contained in a single section we can just discard the section information and use the row value to get a contact from the contacts array. This way, when we're setting up row zero, IndexPath.row is zero.
        let contact = contacts[indexPath.row]
        // the properties below are optional because in some TableViewCell style's the image does not exist in others it does. Because its an optional property, when this is nil it should just silently and gracefully fail without creating any errors.
        cell.textLabel?.text = contact.firstName
        cell.imageView?.image = contact.image
        cell.detailTextLabel?.text = contact.lastName
        return cell
    }

}
