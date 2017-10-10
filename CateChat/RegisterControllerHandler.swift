import UIKit
import Firebase

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func cancelRegister() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func registerUser() {
        
        guard let name = userNameTextField.text, let email = emailTextField.text, let password = passwordNameTextField.text else {
            print("Incorrect name or email")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            // User was created
            
            guard let uid = user?.uid else {
                
                print("No user associated with auth()")
                return
            }
            
            let imageName = UUID().uuidString
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                            Storage.storage().reference().child("Profile Images").child("\(imageName).jpg").putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageURL = metaData!.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                        self.registerUserIntoDatabase(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    @objc func registerUserIntoDatabase(uid: String, values: [String: AnyObject]) {
        let childReference = self.ref.child("users").child(uid)
        childReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // User uid child nodes updated
            let navController = UINavigationController(rootViewController: UserMessageViewController())
            self.present(navController, animated: true, completion: nil)
        })
    }

    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImagePicker: UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImagePicker = originalImage
        } else if let editedImage = info["UIimagePickerControllerEditedImage"] as? UIImage {
            selectedImagePicker = editedImage
        }
        if let selectedImage = selectedImagePicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
