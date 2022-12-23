//
//  Error+Extension.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import ComposableArchitecture

extension Error where Self == AuthClient.Failure {
  func alertState<Action>(dismissAction: Action) -> AlertState<Action> {
    .init(title: .init("Failed"),
          message: .init(self.message),
          dismissButton: .default(.init("OK"), action: .send(dismissAction)))
  }
}

extension Error {
  func alertState<Action>(dismissAction: Action) -> AlertState<Action> {
    .init(title: .init("Failed"),
          message: .init("Encountered some kind of error."),
          dismissButton: .default(.init("OK"), action: .send(dismissAction)))
  }
}
