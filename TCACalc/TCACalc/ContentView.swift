//
//  ContentView.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import SwiftUI
import TCACalc_UI
import ComposableArchitecture


/// The Root View of the entire TCACalc App
struct ContentView: View {
  var body: some View {
    CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init()
        )) {
          CalcScreenReducer()._printChanges()
        }
    )
  }
}

#Preview {
  ContentView()
}

