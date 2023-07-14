//
//  CalcScreenHorizontal.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture

struct CalcScreenHorizontalFeature: ReducerProtocol {
  struct State: Equatable {
    var currentNum: Decimal = 0
  }
  enum Action: Equatable {
    //    case internalAction
    
    case view(View)
    enum View: Equatable {
      //      case viewAction
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      //      case delegateAction
    }
    
    
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
          
      }
    }
  }
}

import SwiftUI

struct CalcScreenHorizontal: View {
  let store: StoreOf<CalcScreenHorizontalFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text(viewStore.currentNum.formatted())
    }
  }
}

#Preview("CalcScreenHorizontal", traits: .landscapeLeft) {
  CalcScreenHorizontal(store: .init(initialState: .init(), reducer: {
    CalcScreenHorizontalFeature()
  }))
}
