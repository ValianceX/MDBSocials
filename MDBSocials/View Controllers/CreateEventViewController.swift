//
//  CreateEventViewController.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var eventDate: Date?
    private var datePicker: UIDatePicker?
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var imageURL = ""
    var userEmail: String?
    var username: String!
    
    //code for datepicker
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
        getUsername()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        dateTextField.inputView = datePicker
        timeTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(CreateEventViewController.dateChanged(datePicker:)), for: .valueChanged)
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy "
        timeFormatter.dateFormat = "hh:mm"
        
        eventDate = datePicker.date
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        timeTextField.text = timeFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onCreateEventButton(_ sender: Any) {
        print(imageURL)
        if imageURL == "" {
            print("No image was selected!")
        }
        else {
            guard let eventName = eventTitleTextField.text, eventName != "" else {
                errorLabel.text = "You must provide an event name!"
                return
            }
            
            guard let description = descriptionTextView.text, description != "" else {
                errorLabel.text = "You must provide a description!"
                return
            }
            
            guard let eventDate = eventDate else {
                errorLabel.text = "You must provide a date and time!"
                return
            }
            
            
            let newEvent = Event(eventName: eventName, description: description, imageURL: imageURL, userPosted: self.username, eventDate: eventDate, interested: 0)
            
            
            var ref: DocumentReference? = nil
            ref = self.db.collection("events").addDocument(data: newEvent.dictionary) { error in
                if let error = error {
                    print("Error adding document")
                } else {
                    print("Successfully added document")
                }
            }
  
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    
    @IBAction func onSelectPhotoButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        //make a new document for this event
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
                
        storage.child("images/file.png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("images/file.png").downloadURL { (url, error) in
                guard let url = url, error==nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.imageURL = urlString
                self.uploadImageView.loadImage(withUrl: URL(string: urlString)!)
            }
        })
        //upload image data
        //get download url
        //save downlload url to userDefaults

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getUsername() {
        userEmail = Auth.auth().currentUser?.email
        db.collection("users").whereField("email", isEqualTo: userEmail).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                } else {
                    self.username = querySnapshot!.documents[0]["username"] as! String
                    print(self.username)
                }
        }
    }
    
}
