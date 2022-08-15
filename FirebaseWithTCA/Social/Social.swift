//
//  Social.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/15.
//

import ComposableArchitecture
import SwiftUI

struct SocialState: Equatable {
}

enum SocialAction: Equatable {
}

let SocialReducer = Reducer<SocialState, SocialAction, SocialEnvironment> { state, action, env in
    switch action {
    }
    return .none
}

struct SocialEnvironment {
}

struct SocialView: View {
    let store: Store<SocialState, SocialAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
