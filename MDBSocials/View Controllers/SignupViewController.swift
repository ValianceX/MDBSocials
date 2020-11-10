//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.text = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSignupButton(_ sender: Any) {
        guard let email = emailTextField.text, email != "" else {
            errorLabel.text = "You must provide an email!"
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            errorLabel.text = "You must provide a password!"
            return
        }
        
        guard let username = usernameTextField.text, username != "" else {
            errorLabel.text = "You must provide a username"
            return
        }
        
        guard let fullname = fullnameTextField.text, fullname != "" else {
            errorLabel.text = "Please provide your full name"
            return
        }
        
        FirebaseAuthManager.shared.register(withEmail: email, password: password, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let user):
                var newUser: User?
                
                if let email = strongSelf.emailTextField.text, let username = strongSelf.usernameTextField.text, let fullname = strongSelf.fullnameTextField.text {
                    newUser = User(email: email, fullname: fullname, username: username)
                } else {return}
                
                //create a new user in the users collection
                var ref: DocumentReference? = nil
                ref = strongSelf.db.collection("users").addDocument(data: newUser!.dictionary)
                
                //segue to the main feed
                strongSelf.performSegue(withIdentifier: "signupToFeed", sender: nil)
            case .failure(let error):
                switch error {
                case .emailInUse:
                    strongSelf.errorLabel.text = "Email already in use"
                case .weakPassword:
                    strongSelf.errorLabel.text = "Weak Password"
                case .generalError:
                    strongSelf.errorLabel.text = "Unknown error"
                }
            }
            
        })

        /*
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (user, error) in
            if let u = user {
                
                var newUser: User?
                
                if let email = self.emailTextField.text, let username = self.usernameTextField.text, let fullname = self.fullnameTextField.text {
                    newUser = User(email: email, fullname: fullname, username: username)
                } else {return}
                
                //create a new user in the users collection
                var ref: DocumentReference? = nil
                ref = self.db.collection("users").addDocument(data: newUser!.dictionary)
                
                //segue to the main feed
                self.performSegue(withIdentifier: "signupToFeed", sender: self)
            }
        }
 */
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        performSegue(withIdentifier: "SignupToSignin", sender: self)
    }
    
}
