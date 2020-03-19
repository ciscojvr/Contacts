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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContact" {
            if let indexPath = tableView.indexPathForSelectedRow { // this lets us know which row was tapped on. this is an optional property (tableView.indexPathForSelectedRow) because if no row is selected, the value is obviously nil. So we unwrap using if let statement.
                let contact = contacts[indexPath.row] // With an index path, since the data source, the contacts array, and rows correspond to one another we use this to figure out which contact the user selected.
                
                // gets the destination of the segue. Need to go to navigation controller first because that's where ContactDetailController is embedded in.
                guard let navigationController = segue.destination as? UINavigationController,
                    let contactDetailController = navigationController.topViewController as? ContactDetailController else { return }
                
                contactDetailController.contact = contact
            }
        }
    }

}
