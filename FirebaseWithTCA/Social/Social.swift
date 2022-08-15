//
//  Social.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/15.
//

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthUI
import SwiftUI

struct SocialState: Equatable {
}

enum SocialAction: Equatable {
    case signInWithGoogle
    case signInWithApple
    case signinWithFacebook
}

let SocialReducer = Reducer<SocialState, SocialAction, SocialEnvironment> { state, action, env in
    switch action {
    case .signInWithGoogle:
        break
    case .signInWithApple:
        break
    case .signinWithFacebook:
        break
    }
    return .none
}

struct SocialEnvironment {
}

struct SocialView: View {
    let store: Store<SocialState, SocialAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Button {
                    viewStore.send(.signInWithGoogle)
                } label: {
                    Text("Sign in with Google")
                        .padding()
                }
                Button {
                    viewStore.send(.signInWithApple)
                } label: {
                    Text("Sign in with Apple")
                        .padding()
                }
                Button {
                    viewStore.send(.signinWithFacebook)
                } label: {
                    Text("Sign in with Facebook")
                        .padding()
                }
            }
        }
    }
}

struct Social_Previews: PreviewProvider {
    static var previews: some View {
        SocialView(store: .init(initialState: .init(),
                                reducer: SocialReducer,
                                environment: .init()))
    }
}
