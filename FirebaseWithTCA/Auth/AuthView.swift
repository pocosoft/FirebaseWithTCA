//
//  AuthView.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import ComposableArchitecture
import FirebaseAuth
import SwiftUI

struct Auth: ReducerProtocol {
  struct State: Equatable {
    var email: String = ""
    var password: String = ""
    var alert: AlertState<Auth.Action>?
    fileprivate(set) var currentUser: User?
  }
  enum Action: Equatable {
    case onAppear
    case setEmail(String)
    case setPassword(String)
    case createUserButtonTapped
    case createUserResult(Result<AuthDataResult, AuthClient.Failure>)
    case signInButtonTapped
    case signInWithEmailPasswordResult(Result<AuthDataResult, AuthClient.Failure>)
    case signOutButtonTapped
    case alertDismissed
  }
  @Dependency(\.authClient) private var authClient
  @Dependency(\.mainQueue) private var mainQueue
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .onAppear:
      state.currentUser = authClient.currentUser()
    case .setEmail(let email):
      state.email = email
    case .setPassword(let password):
      state.password = password
    case .createUserButtonTapped:
      struct CreateUser: Hashable {}
      return authClient.createUser(state.email, state.password)
        .receive(on: mainQueue)
        .catchToEffect(Auth.Action.createUserResult)
        .cancellable(id: CreateUser(), cancelInFlight: true)
    case .createUserResult(let result):
      switch result {
      case .success:
        state.alert = .init(title: .init("Success"),
                            message: .init("Successfully created user."),
                            dismissButton: .default(.init("OK"), action: .send(.alertDismissed)))
      case .failure(let error):
        state.alert = error.alertState(dismissAction: Auth.Action.alertDismissed)
      }
      return Effect(value: .onAppear)
    case .signInButtonTapped:
      struct SignInWithEmailPassowrd: Hashable {}
      return authClient.signInWithEmailPassowrd(state.email, state.password)
        .receive(on: mainQueue)
        .catchToEffect(Auth.Action.signInWithEmailPasswordResult)
        .cancellable(id: SignInWithEmailPassowrd(), cancelInFlight: true)
    case .signInWithEmailPasswordResult(let result):
      switch result {
      case .success:
        state.alert = .init(title: .init("Success"),
                            message: .init("Email Password authentication succeeded."),
                            dismissButton: .default(.init("OK"), action: .send(.alertDismissed)))
      case .failure(let error):
        state.alert = error.alertState(dismissAction: Auth.Action.alertDismissed)
      }
      return Effect(value: .onAppear)
    case .signOutButtonTapped:
      authClient.signOut()
      return Effect(value: .onAppear)
    case .alertDismissed:
      state.alert = nil
    }
    return .none
  }
}

struct AuthState: Equatable {
    var email: String = ""
    var password: String = ""
    var alert: AlertState<AuthAction>?
    fileprivate(set) var currentUser: User?
}

enum AuthAction: Equatable {
    case onAppear
    case setEmail(String)
    case setPassword(String)
    case createUserButtonTapped
    case createUserResult(Result<AuthDataResult, AuthClient.Failure>)
    case signInButtonTapped
    case signInWithEmailPasswordResult(Result<AuthDataResult, AuthClient.Failure>)
    case signOutButtonTapped
    case alertDismissed
}

struct AuthView: View {
  let store: StoreOf<Auth>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack {
          emailPasswordSection(viewStore)
          Spacer().frame(height: 32)
          authStateSection(viewStore)
          Spacer()
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .navigationTitle("Auth")
      .alert(store.scope(state: \.alert), dismiss: Auth.Action.alertDismissed)
    }
  }
        
  private func emailPasswordSection(_ viewStore: ViewStore<Auth.State, Auth.Action>) -> some View {
      Section {
        VStack(alignment: .leading) {
          TextField("Email", text: viewStore.binding(get: \.email, send: Auth.Action.setEmail))
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding()
          Divider()
          SecureField("Password", text: viewStore.binding(get: \.password, send: Auth.Action.setPassword))
            .padding()
          HStack {
            Button {
              viewStore.send(.createUserButtonTapped)
            } label: {
              Text("Create user")
            }
            .padding()
            Divider()
            Button {
              viewStore.send(.signInButtonTapped)
            } label: {
              Text("Sign in")
            }
            .padding()
          }
        }
        .padding()
      } header: {
        Text("Password authentication")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
      }
  }

  @ViewBuilder
  private func authStateSection(_ viewStore: ViewStore<Auth.State, Auth.Action>) -> some View {
    Section {
      if let email = viewStore.currentUser?.email {
        VStack {
          Text(email)
          Divider()
          Button {
              viewStore.send(.signOutButtonTapped)
          } label: {
              Text("Sign out")
          }
        }
      } else {
        EmptyView()
      }
    } header: {
      Text("Status")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
  }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(store: .init(initialState: .init(),
                              reducer: Auth()))
    }
}
