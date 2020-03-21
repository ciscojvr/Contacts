//
//  ContactListController.swift
//  Contacts
//
//  Created by Francisco Ozuna on 3/19/20.
//  Copyright © 2020 Francisco Ozuna. All rights reserved.
//

import UIKit

extension Contact {
    var firstLetterForSort: String {
        return String(firstName.first!).uppercased()
    }
}

extension ContactsSource {
    static var sortedUniqueFirstLetters: [String] { // the reason its static is because the contacts property the underlying data on this type is also a static property and we don't want to worry about creating instances for any of this.
        let firstLetters = contacts.map { $0.firstLetterForSort }
        let uniqueFirstLetters = Set(firstLetters) // this gives us a unique set of first letters. But this is still unordered since sets dont care about order.
        return Array(uniqueFirstLetters).sorted()
    }
    
    static var sectionedContacts: [[Contact]] { // [[Abby, Addy, Axel, [Bailey, Bobby], [Carlos, Cesar]]
        return sortedUniqueFirstLetters.map { firstLetter in
            let filteredContacts = contacts.filter { $0.firstLetterForSort == firstLetter }
            return filteredContacts.sorted(by: { $0.firstName < $1.firstName })
        }
    }
}

class ContactListController: UITableViewController {
    
    var sections = ContactsSource.sectionedContacts
    let sectionTitles = ContactsSource.sortedUniqueFirstLetters

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // when the table view is setting itself up and calls this method, it always provides an argument for which sections its currently in
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { fatalError() }
        
        // since all rows are going to be contained in a single section we can just discard the section information and use the row value to get a contact from the contacts array. This way, when we're setting up row zero, IndexPath.row is zero.
//        let contact = contacts[indexPath.row]
        let contact = sections[indexPath.section][indexPath.row]
        
        contactCell.profileImageView.image = contact.image
        contactCell.nameLabel.text = "\(contact.firstName)"
        contactCell.cityLabel.text = contact.city
        
        if contact.isFavorite {
            contactCell.favoriteIcon.image = #imageLiteral(resourceName: "Star")
        }
        
        return contactCell
    }
    
    // MARK: – Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContact" {
            if let indexPath = tableView.indexPathForSelectedRow { // this lets us know which row was tapped on. this is an optional property (tableView.indexPathForSelectedRow) because if no row is selected, the value is obviously nil. So we unwrap using if let statement.
                let contact = sections[indexPath.section][indexPath.row] // With an index path, since the data source, the contacts array, and rows correspond to one another we use this to figure out which contact the user selected.
                
                // gets the destination of the segue. Need to go to navigation controller first because that's where ContactDetailController is embedded in.
                guard let navigationController = segue.destination as? UINavigationController,
                    let contactDetailController = navigationController.topViewController as? ContactDetailController else { return }
                
                contactDetailController.contact = contact
                contactDetailController.delegate = self
            }
        }
    }
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.street == rhs.street && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zip == rhs.zip && lhs.phone == rhs.phone && lhs.email == rhs.email
    }
}

extension ContactListController: ContactDetailControllerDelegate {
    func didMarkAsFavoriteContact(_ contact: Contact) {
        // if contact were a class it would be the same reference being passed around and you could change the isFavorite property value, and reload the table view. Contact is a struct however, and everything is passed by value, meaning that its just a copy. If you change the property value on the contact passed here as an argument, that does nothing to the copy stored in the array because it is a copy. To get around this we do the below:
        var outerIndex: Int? = nil
        var innerIndex: Int? = nil
        
        // In the beginning all we have is a contact that we favorited. We need to iterate through the data source, the sectioned data, find the spot that this contact is in. Even though this is a copy we can find where in the array is a copy that is equal to this one. So we'll find the spot that the contact is in then we'll grab that copy mutate the right property and assign it back to the data source. In order to do this first we need to iterate over the outer array since the sectioned data is an array of arrays.
        
        for (index, contacts) in sections.enumerated() {
            if let indexOfContact = contacts.index(of: contact) { // need to conform to the Equatable protocol and provide an implementation for double equals (==) in order to be able to do this.
                outerIndex = index
                innerIndex = indexOfContact
                break
            }
        }
        
        if let outerIndex = outerIndex, let innerIndex = innerIndex { // since these variables hold optional values, after we break out of the loop we'll unwrap them using a guard statement.
            var favoriteContact = sections[outerIndex][innerIndex]
            favoriteContact.isFavorite = true //  mutating the stored property of a copy of the contact NOT mutating the underlying value
            sections[outerIndex][innerIndex] = favoriteContact // assigning the copy back into the data source
            
            tableView.reloadData() // reloading the table view so that it runs through the data source methods again 
        }
            
    }
}
