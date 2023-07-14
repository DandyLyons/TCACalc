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
        case let .calcGrid(calcGridAction):
          switch calcGridAction {
            case .view(.onTap(int: let int)):
              state.currentNum.append(int)
              return .none
            case .view(.onTapACButton):
              state.currentNum = 0
              return .none
            case .view(.onTapPercentButton):
              state.currentNum /= 100
              return .none
            case .view(.onTapNegateSignButton):
              state.currentNum *= -1
              return .none
            default:
              return .none
          }
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
        VStack(alignment: .trailing) {
          Spacer()
          
          Text(viewStore.currentNum.formatted())
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(.horizontal)
          
          
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


