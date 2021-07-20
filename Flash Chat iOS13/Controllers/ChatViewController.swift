//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var message:[Message] = [
        Message(sender: "parth@gmail.com", body: "hey"),
        Message(sender: "shalu@gmail.com", body: "hello"),
        Message(sender: "parth@gmail.com", body: "how's u , you know i've something interesting to shre with you we have out yo classes today")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        messageTextfield.delegate = self
        title = K.appName
        navigationItem.hidesBackButton = true
        loadMesssges()
        
    }
    
    func loadMesssges(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{ (querySnapshot, error) in
            if let e = error {
                print("error in retriving data: \(e)")
            }
            else{
                self.message = []
                if let documents = querySnapshot?.documents{
                    for document in documents {
                        
                        let data = document.data()
                        if let messagebody = data[K.FStore.bodyField] as? String ,let senderMail = data[K.FStore.senderField] as? String {
                            let retrivedMessage = Message(sender: senderMail, body: messagebody)
                            self.message.append(retrivedMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at:.top, animated: true)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text ,let sender = Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField : messageBody ,
                K.FStore.senderField : sender ,
                K.FStore.dateField : Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("there's some error in saving data: \(e)")
                }
                else {
                    print("data saved successfully")
                }
            }
        }
        messageTextfield.endEditing(true)
    }
    
}

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for:indexPath) as! MessageCell
        cell.label.text = message[indexPath.row].body
        //      cell.textLabel?.text = message[indexPath.row].body//trigger it if not using custom Cell
        if message[indexPath.row].sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextfield.text = ""
    }
    
}

