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
          currentOrientation: .landscapeLeft,
          userSettings: .init(isDebugModeOn: false, colorSchemeMode: .light)
        ),
        reducer: {
          CalcScreenReducer()._printChanges()
        })
    )
    
  }
}

#Preview {
    ContentView()
}
