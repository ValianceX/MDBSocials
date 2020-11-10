//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var interestedButton: UIButton!
    @IBOutlet weak var interestedLabel: UILabel!
    
    var interested = false
    let db = Firestore.firestore()
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //convert date back to date and time
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy "
        timeFormatter.dateFormat = "hh:mm"
        let dateText = dateFormatter.string(from: event.eventDate)
        let timeText = timeFormatter.string(from: event.eventDate)

        //get image from firebase URL
        let imageUrlString = event.imageURL
        let imageUrl:URL = URL(string: imageUrlString)!
        eventImageView.loadImage(withUrl: imageUrl)
        
        
        // Do any additional setup after loading the view.
        eventTitleLabel.text = event.eventName
        //separate time and date
        dateLabel.text = "Date: " + dateText
        timeLabel.text = "Time: " + timeText
        descriptionTextView.text = event.description
        interestedLabel.text = String(event.interested) + " are interested"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onInterestedButton(_ sender: Any) {
        if (!interested) {
            //access database event and add one to the interested number
            interestedButton.setTitle("Not Interested", for: .normal)
            interestedButton.backgroundColor = .green
            interested = true
        }
        else {
            //access database event and take away one from the interested number
            interestedButton.setTitle("Interested", for: .normal)
            interestedButton.backgroundColor = .red
            interested = false
        }
    }
    
}

