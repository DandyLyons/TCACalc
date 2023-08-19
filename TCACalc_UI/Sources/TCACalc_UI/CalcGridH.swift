//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/15/23.
//


import Foundation
import SwiftUI

import ComposableArchitecture

public struct CalcGridHFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    public var isDivideOn = false
    public var isMultiplyOn = false
    public var isMinusOn = false
    public var isPlusOn = false
    public var isInBlankState = true
    
    public init(isDivideOn: Bool = false, isMultiplyOn: Bool = false, isMinusOn: Bool = false, isPlusOn: Bool = false) {
      self.isDivideOn = isDivideOn
      self.isMultiplyOn = isMultiplyOn
      self.isMinusOn = isMinusOn
      self.isPlusOn = isPlusOn
    }
    
    public mutating func turnDivideOn() {
      self.isDivideOn = true
      self.isMultiplyOn = false
      self.isMinusOn = false
      self.isPlusOn = false
    }
    public mutating func turnMultiplyOn() {
      self.isDivideOn = false
      self.isMultiplyOn = true
      self.isMinusOn = false
      self.isPlusOn = false
    }
    public mutating func turnMinusOn() {
      self.isDivideOn = false
      self.isMultiplyOn = false
      self.isMinusOn = true
      self.isPlusOn = false
    }
    public mutating func turnPlusOn() {
      self.isDivideOn = false
      self.isMultiplyOn = false
      self.isMinusOn = false
      self.isPlusOn = true
    }
    public mutating func turnAllOff() {
      self.isDivideOn = false
      self.isMultiplyOn = false
      self.isMinusOn = false
      self.isPlusOn = false
    }
  }
  public enum Action: Equatable {
    //    case internalAction
    
    case view(View)
    public enum View: Equatable {
      case onTapDivideButton
      case onTapMultiplyButton
      case onTapMinusButton
      case onTapPlusButton
      case onTapEqualButton
      case onTap(int: Int)
      case onTapACButton
      case onTapNegateSignButton
      case onTapPercentButton
      case onTapDecimalButton
    }
    case delegate(Delegate)
    public enum Delegate: Equatable {
      
    }
    
    
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case let .view(viewAction):
          switch viewAction {
            case .onTapDivideButton:
              state.turnDivideOn()
              return .none
            case .onTapMultiplyButton:
              state.turnMultiplyOn()
              return .none
            case .onTapMinusButton:
              state.turnMinusOn()
              return .none
            case .onTapPlusButton:
              state.turnPlusOn()
              return .none
            case .onTapEqualButton:
              print("Not yet implemented")
              state.turnAllOff()
              return .none
            case let .onTap(int: int):
              return .none
            case .onTapACButton:
              return .none
            case .onTapNegateSignButton:
              return .none
            case .onTapPercentButton:
              return .none
            case .onTapDecimalButton:
              return .none
          }
          
        case .delegate:
          return .none
      }
    }
  }
}

public struct CalcGridH: View {
  let store: StoreOf<CalcGridHFeature>
  
  public init(store: StoreOf<CalcGridHFeature>) {
    self.store = store
  }
  
  public let grayStyle = CapsuleButtonStyle(foregroundIdleColor: .black, backgroundIdleColor: .gray)
  public let midgrayStyle = CapsuleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .gray)
  public let darkgrayStyle = CapsuleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary)
  public let orangeStyle = CapsuleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .orange)
  
  public let onOrangeBackground = CircleBackground(foreground: .orange, background: .white)
  public let offOrangeBackground = CircleBackground(foreground: .white, background: .orange)
  
  struct ViewState: Equatable {
    let isDivideOn: Bool
    let isMultiplyOn: Bool
    let isMinusOn: Bool
    let isPlusOn: Bool
    let isInBlankState: Bool
    
    init(state: CalcGridHFeature.State) {
      self.isDivideOn = state.isDivideOn
      self.isMultiplyOn = state.isMultiplyOn
      self.isMinusOn = state.isMinusOn
      self.isPlusOn = state.isPlusOn
      self.isInBlankState = state.isInBlankState
    }
  }
  
  public var body: some View {
    WithViewStore(self.store, observe: ViewState.init ) { viewStore in
      
      
      Grid(alignment: .center, horizontalSpacing: 8.0, verticalSpacing: 8.0) {
        
        self.row1(viewStore)
        self.row2(viewStore)
        self.row3(viewStore)
        self.row4(viewStore)
        self.row5(viewStore)
        
      }
      .fontWeight(.bold)
      
      
    }
  }
  
  
  func row1(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {} label: { Text("(") }
        Button {} label: { Text(")") }
        Button {} label: { Text("mc") }
        Button {} label: { Text("m+") }
        Button {} label: { Text("m-") }
        Button {} label: { Text("mr") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button {viewStore.send(.view(.onTapACButton))} label: { Text("AC") }
        Button { viewStore.send(.view(.onTapNegateSignButton))} label: {Image(systemName: "plus.forwardslash.minus") }
        Button {viewStore.send(.view(.onTapPercentButton))} label: { Text("%") }
      }.buttonStyle(self.grayStyle)
      Button {viewStore.send(.view(.onTapDivideButton))} label: { Image(systemName: "divide") }
        .modifier(viewStore.isDivideOn ? self.onOrangeBackground : self.offOrangeBackground)
    }
  }
  
  func row2(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {} label: { Text("2") + Text("nd".attributed().superscripted()) }
        Button {} label: { Text("x".attributed() + "2".attributed().superscripted()) }
        Button {} label: { Text("x".attributed() + "3".attributed().superscripted()) }
        Button {} label: { Text("x".attributed() + "y".attributed().superscripted()) }
        Button {} label: { Text("e".attributed() + "x".attributed().superscripted()) }
        Button {} label: { Text("10".attributed() + "x".attributed().superscripted()) }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 7)))} label: { Text("7") }
        Button { viewStore.send(.view(.onTap(int: 8)))} label: { Text("8") }
        Button { viewStore.send(.view(.onTap(int: 9)))} label: { Text("9") }
      }.buttonStyle(self.midgrayStyle)
      Button { viewStore.send(.view(.onTapMultiplyButton))} label: { Image(systemName: "multiply") }
        .modifier(viewStore.isMultiplyOn ? self.onOrangeBackground : self.offOrangeBackground)
    }
  }
  
  func row3(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button { } label: { Text("1/x") }
        Button {} label: { Text("2".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button {} label: { Text("3".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button {} label: { Text("y".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button {} label: { Text("ln") }
        Button {} label: { Text("log") + Text("10".attributed().subscripted()) }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 4)))} label: { Text("4") }
        Button { viewStore.send(.view(.onTap(int: 5)))} label: { Text("5") }
        Button { viewStore.send(.view(.onTap(int: 6)))} label: { Text("6") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapMinusButton))} label: { Image(systemName: "minus") }
        .modifier(viewStore.isMinusOn ? self.onOrangeBackground : self.offOrangeBackground)
    }
  }
  
  func row4(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {} label: { Text("x!") }
        Button {} label: { Text("sin") }
        Button {} label: { Text("cos") }
        Button {} label: { Text("tan") }
        Button {} label: { Text("e") }
        Button {} label: { Text("EE") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 1)))} label: { Text("1") }
        Button { viewStore.send(.view(.onTap(int: 2)))} label: { Text("2") }
        Button { viewStore.send(.view(.onTap(int: 3)))} label: { Text("3") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapPlusButton))} label: { Image(systemName: "plus")}
        .modifier(viewStore.isPlusOn ? self.onOrangeBackground : self.offOrangeBackground)
    }
  }
  
  func row5(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {} label: { Text("Rad") }
        Button {} label: { Text("sinh") }
        Button {} label: { Text("cosh") }
        Button {} label: { Text("tanh") }
        Button {} label: { Text("π") }
        Button {} label: { Text("Rand") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 0)))} label: { Text("0") }
          .gridCellColumns(2)
        
        Button(".") { viewStore.send(.view(.onTapDecimalButton)) }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapEqualButton))} label: { Image(systemName: "equal") }
        .modifier(self.offOrangeBackground)
    }
  }
  
  
  
  
//
//  public var oldBody: some View {
//    WithViewStore(self.store, observe: { $0 } ) { viewStore in
//      
//      
//      Grid(alignment: .center, horizontalSpacing: 8.0, verticalSpacing: 8.0) {
//        GridRow {
//          Button(viewStore.isInBlankState ? "AC" : "C") { viewStore.send(.view(.onTapACButton)) }
//            .buttonStyle(self.grayStyle)
//          Button { viewStore.send(.view(.onTapNegateSignButton))} label: { Image(systemName: "plus.forwardslash.minus")}
//            .buttonStyle(self.grayStyle)
//          Button("%") { viewStore.send(.view(.onTapPercentButton)) }
//            .buttonStyle(self.grayStyle)
//          Button { viewStore.send(.view(.onTapDivideButton)) } label: {
//            Image(systemName: "divide")
//              .modifier(viewStore.isDivideOn ? self.onOrangeBackground : self.offOrangeBackground)
//          }
//        }
//        GridRow {
//          Button("7") { viewStore.send(.view(.onTap(int: 7))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("8") { viewStore.send(.view(.onTap(int: 8))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("9") { viewStore.send(.view(.onTap(int: 9))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button { viewStore.send(.view(.onTapMultiplyButton)) } label: {
//            Image(systemName: "multiply")
//              .modifier(viewStore.isMultiplyOn ? self.onOrangeBackground : self.offOrangeBackground)
//          }
//        }
//        GridRow {
//          Button("4") { viewStore.send(.view(.onTap(int: 4))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("5") { viewStore.send(.view(.onTap(int: 5))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("6") { viewStore.send(.view(.onTap(int: 6))) }
//            .buttonStyle(self.darkgrayStyle)
//          
//          Button { viewStore.send(.view(.onTapMinusButton)) } label: {
//            Image(systemName: "minus")
//              .modifier(viewStore.isMinusOn ? self.onOrangeBackground : self.offOrangeBackground)
//          }
//        }
//        GridRow {
//          Button("1") { viewStore.send(.view(.onTap(int: 1))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("2") { viewStore.send(.view(.onTap(int: 2))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button("3") { viewStore.send(.view(.onTap(int: 3))) }
//            .buttonStyle(self.darkgrayStyle)
//          Button { viewStore.send(.view(.onTapPlusButton)) } label: {
//            Image(systemName: "plus")
//              .modifier(viewStore.isPlusOn ? self.onOrangeBackground : self.offOrangeBackground)
//          }
//        }
//        GridRow {
//          Button { viewStore.send(.view(.onTap(int: 0)))} label: { Text("0").foregroundStyle(.white)}
//            .frame(maxHeight: .infinity)
//            .gridCellColumns(2)
//            .gridCellUnsizedAxes(.vertical)
//            .frame(maxWidth: .infinity)
//            .background { Capsule().foregroundColor(.secondary) }
//          
//          
//          Button(".") {}
//            .buttonStyle(self.darkgrayStyle)
//          Button { viewStore.send(.view(.onTapEqualButton)) } label: {
//            Image(systemName: "equal")
//              .modifier(self.offOrangeBackground)
//          }
//        }
//        
//      }
//      .font(.title)
//      .fontWeight(.bold)
//      
//    }
//  }
}



#Preview("CalcGridH"
         , traits: .landscapeLeft
) {
  ZStack {
    Color.black
      .ignoresSafeArea()
    VStack {
      Spacer()
      
      CalcGridH(store: Store(initialState: .init(), reducer: {
        CalcGridHFeature()._printChanges()
      }))
    }
    .padding(.horizontal)
  }
  
}
