//
//  FirebaseWithTCAApp.swift
//  FirebaseWithTCA
//
//  Created by Akihiro Orikasa on 2022/08/02.
//

import Firebase
import SwiftUI
import CombineSchedulers

@main
struct FirebaseWithTCAApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(store: .init(initialState: .init(),
                               reducer: Content()))
    }
  }
}
