//
//  ContactDetailController.swift
//  Contacts
//
//  Created by Francisco Ozuna on 3/19/20.
//  Copyright © 2020 Francisco Ozuna. All rights reserved.
//

import UIKit

protocol ContactDetailControllerDelegate: class { // a class bound protocol
    func didMarkAsFavoriteContact(_ contact: Contact)
}

class ContactDetailController: UITableViewController {
    // we'll always be initializing this TableViewController using init coders, since we're using storyboard to build our layout. Since we won't be able to assign an initial value to the contact stored property during initialization, we have to create an optional property and assign nil to start off. 
    
    var contact: Contact?
    
    // Outlets
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    weak var delegate: ContactDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        guard let contact = contact else { return }
        profileView.image = contact.image
        nameLabel.text = "\(contact.firstName) \(contact.lastName)"
        
        phoneNumberLabel.text = contact.phone
        emailLabel.text = contact.email
        
        streetAddressLabel.text = contact.street
        cityLabel.text = contact.city
        stateLabel.text = contact.state
        zipLabel.text = contact.zip
    }

    @IBAction func markAsFavorite(_ sender: Any) {
        guard let contact = contact else { return }
        delegate?.didMarkAsFavoriteContact(contact)
    }
}
