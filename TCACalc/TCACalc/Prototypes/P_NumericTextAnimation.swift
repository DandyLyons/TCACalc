//
//  P_NumericAnimation.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/15/23.
//


import Foundation
import ComposableArchitecture

struct P_NumericTextAnimationFeature: ReducerProtocol {
  struct State: Equatable {
    var currentOrangeButton: CurrentOrangeButton = .none
    enum CurrentOrangeButton {
      case divide, multiply, minus, plus, equal, none
    }
    var currentNum: Decimal = 0
    var numBuffer: Decimal = 0
    
    var calcGrid: CalcGridFeature.State
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    // SUBVIEWS
    case calcGrid(CalcGridFeature.Action)
    
    case view(View)
    enum View: Equatable {
      case onTapUpdateNumberButton
      
      
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
            case .onTapUpdateNumberButton:
              state.currentNum = state.numBuffer
              state.numBuffer = 0
              return .none
          }
          
        case let .delegate(delegateAction):
          //          switch delegateAction {
          //
          //          }
          return .none
          
          // SPYING ON SUBVIEWS
        case let .calcGrid(.view(calcGridViewAction)):
          switch calcGridViewAction {
            case let .onTap(int: int):
              state.numBuffer.append(int)
              return .none
              
              
            default:
              return .none
          }
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

struct P_NumericTextAnimation: View {
  let store: StoreOf<P_NumericTextAnimationFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.black
          .ignoresSafeArea()
        
        VStack(alignment: .trailing, spacing: 0) {
          Spacer()
          
          Button("Update Number") { viewStore.send(.view(.onTapUpdateNumberButton))}
            .buttonStyle(.borderedProminent)
          
          Text(viewStore.currentNum.formatted())
            .monospacedDigit()
            .font(.system(size: 72))
          //            .truncationMode(.head)
            .foregroundColor(.white)
            .padding()
            .animation(.snappy, value: viewStore.currentNum)
            .contentTransition(.numericText())
          
          CalcGrid(store: self.store.scope(state: \.calcGrid,
                                           action: P_NumericTextAnimationFeature.Action.calcGrid)
          )
        }
        .padding(.horizontal)
      }
    }
  }
}

#Preview("P_NumericTextAnimation") {
  P_NumericTextAnimation(store: .init(initialState: .init(calcGrid: .init()), reducer: {
    P_NumericTextAnimationFeature()._printChanges()
  }))
}

//#Preview("P_NumericTextAnimation") {
//  P_NumericTextAnimation(store: .init(initialState: .init(hScreen: .init(),
//                                              vScreen: .init(calcGrid: .init()),
//                                              currentOrientation: .portrait
//                                             ),
//                          reducer: {
//    P_NumericTextAnimationFeature()._printChanges()
//  }))
//}


