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
    currentUser: { FirebaseAuth.Auth.auth().currentUser },
    createUser: { createUser($0, $1) },
    signInWithEmailPassowrd: { signInWithEmailPassowrd($0, $1) },
    signOut: { signOut() }
  )
  
  private static func createUser(_ email: String, _ password: String) -> Effect<AuthDataResult, Failure> {
    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password)
      .mapError { Failure(message: $0.localizedDescription) }
      .eraseToEffect()
  }
  
  private static func signInWithEmailPassowrd(_ email: String, _ password: String) -> Effect<AuthDataResult, Failure> {
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password)
      .mapError { Failure(message: $0.localizedDescription) }
      .eraseToEffect()
  }
  
  private static func signOut() {
    try? FirebaseAuth.Auth.auth().signOut()
  }
}

extension AuthClient: DependencyKey {
  static var liveValue: AuthClient {
    .live
  }
}

extension DependencyValues {
  var authClient: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}
