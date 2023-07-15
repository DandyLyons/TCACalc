//
//  CalcScreenVerticalFeature.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import ComposableArchitecture

struct CalcScreenVerticalFeature: ReducerProtocol {
  struct State: Equatable {
    var currentOrangeButton: CurrentOrangeButton = .none
    enum CurrentOrangeButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: Decimal = 0
    
    var calcGrid: CalcGridFeature.State
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGrid(CalcGridFeature.Action)
    
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
        case .calcGrid:
          return .none
      }
    }
    
    Scope(state: \.calcGrid, action: /Action.calcGrid) {
      CalcGridFeature()
    }
  }
}

import SwiftUI
import TCACalc_UI

struct CalcScreenVertical: View {
  let store: StoreOf<CalcScreenVerticalFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.black
          .ignoresSafeArea()
        
        VStack(alignment: .trailing, spacing: 0) {
          Spacer()
          
          Text(viewStore.currentNum.formatted())
            .font(.system(size: 72))
//            .truncationMode(.head)
            .foregroundColor(.white)
            .padding()
            
            
          
          
          CalcGrid(store: self.store.scope(state: \.calcGrid,
                                           action: CalcScreenVerticalFeature.Action.calcGrid)
          )
        }
        .padding(.horizontal)
      }
    }
  }
}

//#Preview("CalcScreenVertical") {
//  CalcScreenVertical(store: .init(initialState: .init(calcGrid: .init()), reducer: {
//    CalcScreenVerticalFeature()._printChanges()
//  }))
//}

#Preview("CalcScreenVertical (in CalcScreen)") {
  CalcScreen(store: .init(initialState: .init(hScreen: .init(),
                                              vScreen: .init(calcGrid: .init()),
                                              currentOrientation: .portrait
                                             ),
                          reducer: {
    CalcScreenFeature()._printChanges()
  }))
}


