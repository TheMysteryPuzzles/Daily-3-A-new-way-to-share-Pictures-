//
//  NewPost.swift
//  Storify
//
//  Created by Work on 5/1/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleImageSelection(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
     
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
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
            self.image = selectedImage
            
            selectedImageView.image = self.image
        }
        DispatchQueue.main.async {
            self.setImageAccordingTotimeOfDay()
            if self.newPostButton.isEnabled == false {self.newPostButton.isEnabled = true}
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setImageAccordingTotimeOfDay(){
        switch selectedTimeOfDay!  {
        case .Morning: morningImage = selectedImageView.image
        case .Evening: eveningImage = selectedImageView.image
        case .Night:   nightImage = selectedImageView.image
        }
    }
    

}

extension NewPostViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPostCell", for: indexPath) as! NewPostCell
        cell.backgroundColor = UIColor.white
      
    switch indexPath.item {
    case 0: if isAllowedToDoNewPost{
        cell.postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleEveningImageSelection(tapGestureRecognizer:))))
    }else{
        if self.lastPost.eveningImagePostInfo?.thumb_Url != nil{
            cell.postImageView.loadImageUsingCache(withUrl: (self.lastPost.eveningImagePostInfo?.thumb_Url)!)}
        }
                
                
    case 1: if isAllowedToDoNewPost{
        cell.postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleMorningImageSelection(tapGestureRecognizer:))))}
    else{
        if self.lastPost.morningImagePostInfo?.thumb_Url != nil{
            cell.postImageView.loadImageUsingCache(withUrl: (self.lastPost.morningImagePostInfo?.thumb_Url)!)}
        }
                
                
    case 2: if isAllowedToDoNewPost{cell.postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleNightImageSelection(tapGestureRecognizer:))))}
    else{
        if self.lastPost.nightImagePostInfo?.thumb_Url != nil{
            cell.postImageView.loadImageUsingCache(withUrl: (self.lastPost.nightImagePostInfo?.thumb_Url)!)}
        }
        
   default:
           break
        }
        
        return cell
    }
}













