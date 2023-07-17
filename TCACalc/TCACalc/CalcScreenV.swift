//
//  CalcScreenVFeature.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import ComposableArchitecture

struct CalcScreenVFeature: ReducerProtocol {
  struct State: Equatable {
    var currentOrangeButton: CurrentOrangeButton = .none
    enum CurrentOrangeButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: Decimal = 0
    
    var calcGridV: CalcGridVFeature.State
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGridV(CalcGridVFeature.Action)
    
    case view(View)
    enum View: Equatable {
      
      
      
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      //      case delegateAction
    }
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case let .view(viewAction):
          switch viewAction {
            
          }
          
        case let .delegate(delegateAction):
//          switch delegateAction {
//              
//          }
          return .none
          
          // SPYING ON SUBVIEWS
        case .calcGridV:
          return .none
      }
    }
    
    Scope(state: \.calcGridV, action: /Action.calcGridV) {
      CalcGridVFeature()
    }
  }
}

import SwiftUI
import TCACalc_UI

struct CalcScreenVertical: View {
  let store: StoreOf<CalcScreenVFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.black
          .ignoresSafeArea()
        
        VStack(alignment: .trailing, spacing: 0) {
          Spacer()
          
          Text(viewStore.currentNum.formatted())
            .font(.system(size: 72))
            .foregroundColor(.white)
            .padding()
            .contentTransition(.numericText(countsDown: false))
            .animation(.snappy, value: viewStore.currentNum)
          
          CalcGridV(store: self.store.scope(state: \.calcGridV,
                                           action: CalcScreenVFeature.Action.calcGridV)
          )
        }
        .padding(.horizontal)
      }
    }
  }
}

//#Preview("CalcScreenVertical") {
//  CalcScreenVertical(store: .init(initialState: .init(calcGridV: .init()), reducer: {
//    CalcScreenVFeature()._printChanges()
//  }))
//}

#Preview("CalcScreenVertical (in CalcScreen)") {
  CalcScreen(store: .init(initialState: .init(hScreen: .init(calcGridH: .init()),
                                              vScreen: .init(calcGridV: .init()),
                                              currentOrientation: .portrait
                                             ),
                          reducer: {
    CalcScreenFeature()._printChanges()
  }))
}


