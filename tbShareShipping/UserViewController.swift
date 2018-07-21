//
//  UserViewController.swift
//  taobaoWeight
//
//  Created by Peter on 2018/6/30.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EnterWeightDelegate {
    

    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var totalPriceTextField: UITextField!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var totalweightLabel: UILabel!
    var footerButton: UIButton!
    
    var maxUserID: Int = 0
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        let cellNib = UINib(nibName: "UserCell", bundle: nil)
        self.userTableView.register(cellNib, forCellReuseIdentifier: "UserCell")
        
        let footerNib = UINib(nibName: "addUserFooterView", bundle: Bundle.main)
        self.userTableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "addUserFooterView")
        
        calculateButton .addTarget(self, action: #selector(calculate), for: .touchUpInside)
        
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.keyboardDismissMode = .onDrag
        self.userTableView.allowsSelection = false
        
        userArray.append(User(userID: 0, name: "User1", fee: 0, weight: 0))
        userArray.append(User(userID: 1, name: "User2", fee: 0, weight: 0))
        maxUserID = 1
        
        self.totalPriceTextField.placeholder = "$ 0"
        self.totalPriceTextField.keyboardType = .numbersAndPunctuation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTableView.reloadData()
    }
    
    @objc func calculate(){
        self.view .endEditing(true)
        
        var totalWeight: Float = 0.0
        let totalPrice = Float(totalPriceTextField.text!)
        
        for user in userArray {
            totalWeight = totalWeight + user.personalWeight
        }
        
        totalweightLabel.text = "\(totalWeight)kg"
        
        for user in userArray {
            if(totalWeight > 0){
                user.personalFee = totalPrice! * user.personalWeight / totalWeight
            }
        }
        
        self.userTableView .reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
       
        let user = userArray[indexPath.row]
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction(sender:)))
        done.tag = indexPath.row
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        cell.nameTextField.inputAccessoryView = doneToolbar
        cell.nameTextField.placeholder = user.name
        cell.delegate = self
        cell.indexPath = indexPath
        cell.priceLabel.text = "$ \(user.personalFee)"
        cell.weightButton.setTitle("\(user.personalWeight)kg", for: .normal)
        
        //
        cell.weightButton.layer.borderWidth = 1
        cell.priceLabel.layer.borderWidth = 1
        //
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {

            footerButton.frame = CGRect(x: UIScreen.main.bounds.height / 2 - 15, y: 50 / 2 - 15, width: 30, height: 30)
        } else {
            footerButton.frame = CGRect(x: UIScreen.main.bounds.height / 2 - 15, y: 50 / 2 - 15, width: 30, height: 30)
        }
    }
    
    @objc func doneButtonAction(sender:UIBarButtonItem) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = userTableView .cellForRow(at: indexPath) as! UserCell
        let user = userArray[indexPath.row]
        
        user.name = cell.nameTextField.text!
        cell.nameTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "addUserFooterView") as! AddUserFooterView
        
        if((footerView.superview) != nil){
            footerButton .removeFromSuperview()
        }
        footerButton = UIButton(type: .contactAdd)
        footerButton.layer.borderWidth = 1

        footerButton.frame = CGRect(x: tableView.frame.size.width / 2 - 15, y: footerView.frame.size.height / 2 - 15, width: 30, height: 30)
        footerButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        footerView.addSubview(footerButton)
        
        return footerView
    }
    
    @objc func addUser(){
        maxUserID = maxUserID + 1
        userArray.append(User(userID: maxUserID, name: "User\(userArray.count + 1)", fee: 0, weight: 0))
        userTableView.reloadData()
    }
    
    @objc func popWeightInput(cell: UserCell, user: User){
        
    }

    func weightButtonTapped(at index: IndexPath, sender: UIButton) {
        print("button tapped at index:\(index)")
        
        let user = userArray[index.row]
        
        let alert = UIAlertController(title: "\(user.name)", message: "Personal weight", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            if(user.personalWeight == 0.0){
                textField.placeholder = "0.0"
            }else{
                textField.text = "\(user.personalWeight)"
            }
            textField.keyboardType = .numbersAndPunctuation
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
            let textField = alert.textFields![0]
            sender.setTitle("\(textField.text ?? "0.0")kg", for: .normal)
            user.personalWeight = Float(textField.text!)!
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(userArray.count >= 2){
                userArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didselect")
//    }
}
