//
//  CalcScreenHorizontal.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture
import TCACalc_UI

struct CalcScreenHFeature: ReducerProtocol {
  struct State: Equatable {
    var currentNum: Decimal = 0
    var calcGridH: CalcGridHFeature.State
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGridH(CalcGridHFeature.Action)
    
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
          
          // SPYING ON SUBVIEWS
        case .calcGridH:
          return .none
      }
    }
    Scope(state: \.calcGridH, action: /Action.calcGridH) {
      CalcGridHFeature()
    }
    
  }
}

import SwiftUI

struct CalcScreenHorizontal: View {
  let store: StoreOf<CalcScreenHFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      
      ZStack {
        Color.black
          .ignoresSafeArea()
        
        VStack {
          HStack {
            Spacer()
            
            Text(viewStore.currentNum.formatted())
              .font(.largeTitle)
              .foregroundStyle(.white)
              .padding()
              .contentTransition(.numericText(countsDown: false))
              .animation(.snappy, value: viewStore.currentNum)
            
          }
          
          CalcGridH(store: self.store.scope(state: \.calcGridH,
                                            action: CalcScreenHFeature.Action.calcGridH)
          )
        }
        .padding(.horizontal)
      }

    }
  }
}

#Preview("CalcScreenHorizontal", traits: .landscapeLeft) {
  CalcScreenHorizontal(store: .init(initialState: .init(calcGridH: .init()), reducer: {
    CalcScreenHFeature()
  }))
}
