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
    CalcScreen(store: .init(initialState: .init(hScreen: .init(),
                                                vScreen: .init(calcGrid: .init()),
                                                currentOrientation: .portrait
                                               ),
                            reducer: {
      CalcScreenFeature()._printChanges()
    }))
  }
}

#Preview {
    ContentView()
}
