//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var createEventButton: UIButton!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    let db = Firestore.firestore()
    
    var eventArray = [Event]()
    var selectedEvent: Event?
    var userEmail: String?
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var testDate = Date()
        var testEvent = Event(eventName: "test event", description: "not in db", imageURL: "https://firebasestorage.googleapis.com/v0/b/mdb-socials-8ca3b.appspot.com/o/images%2Ffile.png?alt=media&token=369d9ee9-c577-480a-98bc-22078efa0f19", userPosted: "sydney test", eventDate: testDate, interested: 0)
        eventArray.append(testEvent)
        eventCollectionView.reloadData()
        print("added test event \(eventArray)")
        loadData()
        getUsername()
    }
    
    func eventForIndexPath(for indexPath: IndexPath) -> Event {
        return eventArray[indexPath.row]
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
    
    func loadData() {
        db.collection("events").order(by: "eventDate", descending: true).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("An error occured")
            } else {
                print("success")
                print(querySnapshot?.documents )
                var documents = querySnapshot!.documents
                for document in documents {
                    //make a new event object to add to the array made out of the data from the document
                    print("\(document.data())")
                    print(type(of: document.data()))
                    self.eventArray.append(self.makeEventFromData(data: document.data()))
                    print("event array is \(self.eventArray)")
                }
                DispatchQueue.main.async {
                    self.eventCollectionView.reloadData()
                }
            }
        }
    }
    
    
    func makeEventFromData(data: [String: Any]) -> Event {
        print("Making a new event!")
        var userPosted = data["userPosted"] as! String
        var description = data["description"] as! String
        var eventName = data["eventName"] as! String
        var imageURL = data["imageURL"] as! String
        var interested = data["interested"] as! Int
        var timestamp = data["eventDate"] as! Timestamp
        var date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))

        
        
        var newEvent = Event(eventName: eventName, description: description, imageURL: imageURL, userPosted: userPosted, eventDate: date, interested: interested)
        return newEvent
    }
    
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are \(eventArray.count) events")
        return eventArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("there are \(eventArray.count) events")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! eventCollectionViewCell
        
        let event = eventForIndexPath(for: indexPath)
        cell.eventTitleLabel.text = event.eventName
        cell.eventImageView.loadImage(withUrl: URL(string: event.imageURL)!)
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy "
        timeFormatter.dateFormat = "hh:mm"
        cell.dateLabel.text = dateFormatter.string(from: event.eventDate)
        cell.timeLabel.text = timeFormatter.string(from: event.eventDate)
        
        cell.userPostedLabel.text = event.userPosted
        cell.interestedLabel.text = "Interested: " + String(event.interested)
        return cell
    }

    @IBAction func onCreateEventButton(_ sender: Any) {
        performSegue(withIdentifier: "FeedToCreateEventSegue", sender: self)
    }
}

extension UIImageView {
    func loadImage(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
