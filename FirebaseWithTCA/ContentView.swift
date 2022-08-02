//
//  ContentView.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import ComposableArchitecture
import SwiftUI

struct ContentState: Equatable {
    var auth: AuthState?
}

enum ContentAction: Equatable {
    case auth(AuthAction)
    case setNavigationAuth(Bool)
}

let contentReducer = Reducer<ContentState, ContentAction, Environment>.combine(
    authReducer.optional().pullback(state: \.auth,
                                    action: /ContentAction.auth,
                                    environment: { $0 }),
    Reducer { state, action, env in
        switch action {
        case .auth:
            break
        case let .setNavigationAuth(isActive):
            state.auth = isActive ? .init() : nil
        }
        return .none
    }
)

struct ContentView: View {
    
    let store: Store<ContentState, ContentAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    NavigationLink(isActive: viewStore.binding(get: { $0.auth != nil },
                                                               send: {  ContentAction.setNavigationAuth($0) })) {
                        IfLetStore(self.store.scope(state: \.auth, action: ContentAction.auth), then: AuthView.init(store:))
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
                                 reducer: contentReducer,
                                 environment: .live))
    }
}
