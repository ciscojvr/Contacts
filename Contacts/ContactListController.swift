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
    
    let dataSource = ContactsDataSource(sectionedData: ContactsSource.sectionedContacts, sectionTitles: ContactsSource.sortedUniqueFirstLetters)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource // With our new approach after code refactoring, we'll need to tell the table view about the new data source which means that we need to assign the above data source to the data source property on the underlying table view. We do that in this line of code.
    }

    // MARK: – Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContact" {
            if let indexPath = tableView.indexPathForSelectedRow { // this lets us know which row was tapped on. this is an optional property (tableView.indexPathForSelectedRow) because if no row is selected, the value is obviously nil. So we unwrap using if let statement.
                let contact = dataSource.object(at: indexPath) // With an index path, since the data source, the contacts array, and rows correspond to one another we use this to figure out which contact the user selected.
                
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
        
        guard let indexPath = dataSource.indexPath(for: contact) else { return }
        
        var favoriteContact = dataSource.object(at: indexPath)
        favoriteContact.isFavorite = true
        
        dataSource.updateContact(favoriteContact, at: indexPath)
        
        tableView.reloadData()
    }
}
