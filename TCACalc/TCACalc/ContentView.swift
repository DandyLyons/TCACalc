//
//  ContentView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import SwiftUI
import TCACalc_UI
import ComposableArchitecture

struct ContentView: View {
  var body: some View {
    CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init(isDebugModeOn: false, colorSchemeMode: .auto)
        ),
        reducer: {
          CalcScreenReducer()._printChanges()
        }, withDependencies: {
          $0
//          $0.userSettings = .failToWrite
        })
    )
  }
}

#Preview {
    ContentView()
}
