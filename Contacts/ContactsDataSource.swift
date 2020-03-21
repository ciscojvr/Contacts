//
//  ContactsDataSource.swift
//  Contacts
//
//  Created by Francisco Ozuna on 3/21/20.
//  Copyright © 2020 Francisco Ozuna. All rights reserved.
//

import Foundation
import UIKit

class ContactsDataSource: NSObject, UITableViewDataSource { // this has to be a class because any object conforming to an Objective-C protocol, which UITableViewDataSource is, needs to be a subclass of NSObject. Essentially it needs to be an Objective-C Class.
    private var sectionedData: [[Contact]]
    let sectionTitles: [String]
    
    init(sectionedData: [[Contact]], sectionTitles: [String]) {
        self.sectionedData = sectionedData
        self.sectionTitles = sectionTitles
        
        super.init() // need to call the super classes's init method because of NSObject in class declaration
    }
    
    // MARK: - Data Source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // when the table view is setting itself up and calls this method, it always provides an argument for which sections its currently in
        return sectionedData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { fatalError() }
        
        // since all rows are going to be contained in a single section we can just discard the section information and use the row value to get a contact from the contacts array. This way, when we're setting up row zero, IndexPath.row is zero.
        //        let contact = contacts[indexPath.row]
        let contact = sectionedData[indexPath.section][indexPath.row]
        
        contactCell.profileImageView.image = contact.image
        contactCell.nameLabel.text = "\(contact.firstName)"
        contactCell.cityLabel.text = contact.city
        
        if contact.isFavorite {
            contactCell.favoriteIcon.image = #imageLiteral(resourceName: "Star")
        } else {
            contactCell.favoriteIcon.image = nil
        }
        
        return contactCell
    }
    
    // MARK: – Helper Methods
    
    func object(at indexPath: IndexPath) -> Contact {
        return sectionedData[indexPath.section][indexPath.row]
    }
    
    func indexPath(for contact: Contact) -> IndexPath? {
        for (index, contacts) in sectionedData.enumerated() {
            if let indexOfContact = contacts.index(of: contact) {
                return IndexPath(row: indexOfContact, section: index)
            }
        }
        return nil
    }
    
    func updateContact(_ contact: Contact, at indexPath: IndexPath) {
        sectionedData[indexPath.section][indexPath.row] = contact
    }

}
