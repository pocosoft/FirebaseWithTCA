//
//  AuthClient.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import Combine
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift

struct AuthClient {
    var currentUser: () -> User?
    var createUser: (String, String) -> Effect<AuthDataResult, Failure>
    var signInWithEmailPassowrd: (String, String) -> Effect<AuthDataResult, Failure>
    var signOut: () -> Void
    struct Failure: Error, Equatable {
        let message: String
    }
}

extension AuthClient {
    static let live = AuthClient(
        currentUser: { Auth.auth().currentUser },
        createUser: { createUser($0, $1) },
        signInWithEmailPassowrd: { signInWithEmailPassowrd($0, $1) },
        signOut: { signOut() }
    )
    
    private static func createUser(_ email: String, _ password: String) -> Effect<AuthDataResult, Failure> {
        Auth.auth().createUser(withEmail: email, password: password)
            .mapError { Failure(message: $0.localizedDescription) }
            .eraseToEffect()
    }
    
    private static func signInWithEmailPassowrd(_ email: String, _ password: String) -> Effect<AuthDataResult, Failure> {
        Auth.auth().signIn(withEmail: email, password: password)
            .mapError { Failure(message: $0.localizedDescription) }
            .eraseToEffect()
    }
    
    private static func signOut() {
        try? Auth.auth().signOut()
    }
}
