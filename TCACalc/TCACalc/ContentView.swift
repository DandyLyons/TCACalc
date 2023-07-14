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
    CalcScreenVertical(store: .init(initialState: .init(), reducer: {
      CalcScreenVerticalFeature()
    }))
  }
}

#Preview {
    ContentView()
}
