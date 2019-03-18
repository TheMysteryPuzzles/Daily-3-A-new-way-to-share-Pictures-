//
//  LoginHandlers.swift
//  Storify
//
//  Created by Work on 2/26/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    fileprivate func storeUserCredentialsInDataBase(withUid uid: String, values:[String:AnyObject]) {
        let reference = Database.database().reference(fromURL: "https://storify-a9ada.firebaseio.com/")
        let childReference = reference.child("people").child(uid)
        childReference.updateChildValues(values, withCompletionBlock: { (err, reference) in
            if(err != nil){
                print(err!)
            }
            
            
            //Mark-> Dismissing LoginRegister VC Going back to Root VC
            self.activityIndicator.stopAnimating()
           // self.rootVcReference?.navigationItem.title = values["name"] as? String
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func registerUser(){
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            print("Empty")
            let alert = UIAlertController(title: "Empty Fields", message: "Username or password is not entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.view.isHidden = true
                self.loginConatinerView.alpha = 1
                self.loginConatinerView.isOpaque = true
                self.loginRegisterButton.isEnabled = true
            }))
            emailTextField.text = ""
            passwordTextField.text = ""
            present(alert, animated: true, completion: nil)
        }
        
        
        guard let email = emailTextField.text , let password = passwordTextField.text,
            let name = nameTextField.text else{
                print("Invalid Input")
                return
        }
        
        print(email)
        print(password)
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Empty Fields", message: "Email is incorrect or Password is less than 7 characters ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    alert.view.isHidden = true
                }))
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let uid = User?.uid else{
                return
            }
        
    // MARK -> STORING IMAGE TO FIREBASE STRORAGE AND STORING NAME,EMAIL,IMAGE URL TO DATABASE
            
          let updateReq = User?.createProfileChangeRequest()
            updateReq?.displayName = name
            updateReq?.commitChanges(completion: { (error) in
                if error != nil {
                    //ERROR ->
                    print(error!.localizedDescription)
                }else{
                    let credentials = ["name" : name, "email" : email, "_search_index": ["full_name": User!.displayName!.lowercased(),
                                                                                         "reversed_full_name": User!.displayName!.components(separatedBy: " ").reversed().joined(separator: "")]]
                        as [String : AnyObject]
                    self.storeProfileImageAndUserCredientialsToFireBase(withUid: uid, values: credentials)
                }
            })
            
         
        }
  }
    
    
    private func storeProfileImageAndUserCredientialsToFireBase(withUid uid:String ,values: [String:AnyObject]) {
        let imageName = NSUUID().uuidString
        let storageReference = Storage.storage().reference().child("profile_images").child(imageName+".png")
        var valuesWithDownloadUrl = values
        if let profileImage = daily3Logo.image, let uploadData = UIImagePNGRepresentation(profileImage) {
            storageReference.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if(error != nil){
                    print(error!)
                }
               
                if let url = metaData?.downloadURL()?.absoluteString {
                    valuesWithDownloadUrl.updateValue(url as AnyObject, forKey: "photoUrl")
                    
                    let updateReq = Auth.auth().currentUser!.createProfileChangeRequest()
                    updateReq.photoURL = URL(string: url)
                    updateReq.commitChanges(completion: nil)
                }
                
                print("imageUploaded")
                self.storeUserCredentialsInDataBase(withUid: uid, values: valuesWithDownloadUrl)
                print("user stored")
            })
            
        }
        
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker =  editedImage
        }else if let orignalImage = info["UIImagePickerControllerOrignalImage"] as? UIImage {
            selectedImageFromPicker = orignalImage
        }
        if let selectedImage = selectedImageFromPicker {
            daily3Logo.image = selectedImage
        }
        self.imageSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
