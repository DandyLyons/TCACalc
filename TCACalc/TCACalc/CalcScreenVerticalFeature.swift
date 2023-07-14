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
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    case view(View)
    enum View: Equatable {
      case onTap(int: Int)
      
//      case calcGrid(CalcGridFeature.Action)
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
            case let .onTap(int: int):
              state.currentNum.append(int)
              return .none
          }
          
        case let .delegate(delegateAction):
//          switch delegateAction {
//              
//          }
          return .none
      }
    }
  }
}

import SwiftUI

struct CalcScreenVertical: View {
  let store: StoreOf<CalcScreenVerticalFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.black
          .ignoresSafeArea()
        VStack(alignment: .trailing) {
          Spacer()
          
          Text("0")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(.horizontal)
          
//          CalcGrid(isDivideOn: .constant(false), isMultiplyOn: .constant(true), isMinusOn: .constant(false), isPlusOn: .constant(false), isEqualOn: .constant(false))
        }
        .padding(.horizontal)
      }
    }
  }
}


