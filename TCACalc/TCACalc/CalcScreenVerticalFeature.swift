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
    var precedingNum: Decimal = 0
    var isInBlankState: Bool = true
    mutating func determineIfBlank () {
      if self.currentNum == 0,
         self.precedingNum == 0 {
        self.isInBlankState = true
        self.calcGrid.isInBlankState = true
      } else {
        self.isInBlankState = false
        self.calcGrid.isInBlankState = false
      }
    }
    
    var displayedNum: Decimal {
      if self.calcGrid.isDivideOn == false,
         self.calcGrid.isMultiplyOn == false,
         self.calcGrid.isMinusOn == false,
         self.calcGrid.isPlusOn == false {
        return self.currentNum
      } else {
        return self.precedingNum
      }
    }
    
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
    Reduce<State, Action> { state, action in
      state.determineIfBlank()
      return .none
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

//#Preview {
//  Text("Hello")
//}
//
#Preview("CalcScreenVertical") {
  CalcScreenVertical(store: .init(initialState: .init(calcGrid: .init()), reducer: {
    CalcScreenVerticalFeature()._printChanges()
  }))
}


