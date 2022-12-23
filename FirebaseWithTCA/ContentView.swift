//
//  ContentView.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import ComposableArchitecture
import SwiftUI

struct Content: ReducerProtocol {
  struct State: Equatable {
    var auth: Auth.State?
  }
  enum Action: Equatable {
    case auth(Auth.Action)
    case setNavigationAuth(Bool)
  }
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .auth:
      break
    case let .setNavigationAuth(isActive):
      state.auth = isActive ? .init() : nil
    }
    return .none
  }
}

struct ContentView: View {
  let store: StoreOf<Content>
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationView {
        List {
          NavigationLink(isActive: viewStore.binding(get: { $0.auth != nil },
                                                     send: {  Content.Action.setNavigationAuth($0) })) {            
            IfLetStore(store.scope(state: \.auth, action: Content.Action.auth), then: AuthView.init(store:))
          } label: {
            Text("Auth")
              .padding()
          }
        }
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .navigationTitle("Welcome to FirebaseWithTCA")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(store: .init(initialState: .init(),
                               reducer: Content()))
    }
}
