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
    ZStack {
      Color.black
        .ignoresSafeArea()
      VStack(alignment: .trailing) {
        Spacer()
        
        Text("0")
          .font(.largeTitle)
          .foregroundColor(.white)
          .padding(.horizontal)
        
        CalcGrid(isDivideOn: .constant(false), isMultiplyOn: .constant(true), isMinusOn: .constant(false), isPlusOn: .constant(false), isEqualOn: .constant(false))
      }
      .padding(.horizontal)
    }
  }
}

#Preview {
    ContentView()
}
