//
//  FirebaseAuthManager.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/7/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    let db = Firestore.firestore()
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<Firebase.User, FIBAuthError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            if let error = error as NSError? {
                let authError = error as NSError
                switch authError.code {
                case AuthErrorCode.rejectedCredential.rawValue:
                    completion(.failure(.rejectedCredential))
                case AuthErrorCode.userNotFound.rawValue:
                    completion(.failure(.rejectedCredential))
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(.failure(.malformedEmail))
                case AuthErrorCode.networkError.rawValue:
                    completion(.failure(.networkError))
                default:
                    completion((.failure(.generalError)))
                }
                return
            }
            completion(.success(authResult!.user))
        })
                
    }
    
    enum FIBAuthError: Error {
        case emptyEmail, emptyPassword
        case malformedEmail, malformedPassword
        case rejectedCredential, networkError
        case generalError
    }
    
    func register(withEmail email: String, password: String, completion: @escaping (Result<Firebase.User, FIBRegisError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let authError = error as NSError
                switch authError.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(.failure(.emailInUse))
                case AuthErrorCode.weakPassword.rawValue:
                    completion(.failure(.weakPassword))
                default:
                    completion(.failure(.generalError))
                }
                return
            }
            completion(.success(result!.user))
        }
        
    }
    
    enum FIBRegisError: Error {
        case emailInUse
        case generalError
        case weakPassword
    }
}
