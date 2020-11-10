//
//  LoginViewController.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        
        if let user = Auth.auth().currentUser {
            performSegue(withIdentifier: "signinToFeed", sender: nil)
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSigninButton(_ sender: Any) {
        
        guard let email = emailTextField.text, email != "" else {
            errorLabel.text = "You must provide an email!"
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            errorLabel.text = "You must provide a password!"
            return
        }
        
        FirebaseAuthManager.shared.signIn(withEmail: email, password: password, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let user):
                print("Success")
                strongSelf.performSegue(withIdentifier: "signinToFeed", sender: nil)
            case .failure(let error):
                print("Error")
                switch error {
                case .malformedEmail:
                    strongSelf.errorLabel.text = "Invalid email format"
                case .malformedPassword:
                    strongSelf.errorLabel.text = "Invalid password format"
                case .networkError:
                    strongSelf.errorLabel.text = "Network error"
                case .rejectedCredential:
                    strongSelf.errorLabel.text = "Incorrect email or password"
                case .generalError:
                    strongSelf.errorLabel.text = "Unknown error"
                default:
                    strongSelf.errorLabel.text = "Unknown error"
                }
            }
        })
    }
    @IBAction func onSignupButton(_ sender: Any) {
        performSegue(withIdentifier: "SigninToSignup", sender: self)
    }
    
}
