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
    
    public var userSelectedColor: Color = .green
    
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
      
      case onTapSquaredButton
      case onTapCubedButton
      case onTapXToThePowerOfYButton
      case onTap10ToThePowerOfXButton
      case onTap1OverXButton
      case onTapOpenParenthesesButton
      case onTapCloseParenthesesButton
      case onTapMCButton
      case onTapMPlusButton
      case onTapMMinusButton
      case onTapMRButton
      case onTap2ndButton
      case onTapEToThePowerOfXButton
      case onTapSquareRootButton
      case onTapCubeRootButton
      case onTapYRootXButton
      case onTapLNButton
      case onTapLogSub10
      case onTapFactorialButton
      case onTapSinButton
      case onTapCosButton
      case onTapTanButton
      case onTapEButton
      case onTapEEButton
      case onTapRadButton
      case onTapSinHButton
      case onTapCosHButton
      case onTapTanHButton
      case onTapPiButton
      case onTapRandButton
      case onTapSecondButton
    }
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case notYetImplemented
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
              
            
            case .onTapSquaredButton, .onTapCubedButton, .onTapXToThePowerOfYButton, .onTap10ToThePowerOfXButton, .onTap1OverXButton, .onTapOpenParenthesesButton, .onTapCloseParenthesesButton, .onTapMCButton, .onTapMPlusButton, .onTapMMinusButton, .onTapMRButton, .onTap2ndButton, .onTapEToThePowerOfXButton, .onTapSquaredButton, .onTapCubeRootButton, .onTapYRootXButton, .onTapLNButton, .onTapLogSub10, .onTapFactorialButton, .onTapSinButton, .onTapCosButton, .onTapTanButton, .onTapEButton, .onTapEEButton, .onTapRadButton, .onTapSinHButton, .onTapCosHButton, .onTapTanHButton, .onTapPiButton, .onTapRandButton, .onTapSecondButton, .onTapSquareRootButton:
              return .run { await $0(.delegate(.notYetImplemented))}
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
  
  @ViewBuilder
  func withCircleBackground(bool: Bool, color: Color, _ content: () -> some View) -> some View {
    content()
      .if(bool) {
        $0.modifier(self.onTintBackground(color))
      } else: {
        $0.modifier(self.offTintBackground(color))
      }
  }
  
  public func onTintBackground(_ color: Color) -> CircleBackground {
    CircleBackground(foreground: color, background: .white)
  }
  
  public func offTintBackground(_ color: Color) -> CircleBackground {
    .init(foreground: .white, background: color)
  }
  
  public let onOrangeBackground = CircleBackground(foreground: .orange, background: .white)
  public let offOrangeBackground = CircleBackground(foreground: .white, background: .orange)
  
  struct ViewState: Equatable {
    let isDivideOn: Bool
    let isMultiplyOn: Bool
    let isMinusOn: Bool
    let isPlusOn: Bool
    let isInBlankState: Bool
    
    let userSelectedColor: Color
    
    init(state: CalcGridHFeature.State) {
      self.isDivideOn = state.isDivideOn
      self.isMultiplyOn = state.isMultiplyOn
      self.isMinusOn = state.isMinusOn
      self.isPlusOn = state.isPlusOn
      self.isInBlankState = state.isInBlankState
      self.userSelectedColor = state.userSelectedColor
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
        Button {viewStore.send(.view(.onTapOpenParenthesesButton))} label: { Text("(") }
        Button {viewStore.send(.view(.onTapCloseParenthesesButton))} label: { Text(")") }
        Button {viewStore.send(.view(.onTapMCButton))} label: { Text("mc") }
        Button {viewStore.send(.view(.onTapMPlusButton))} label: { Text("m+") }
        Button {viewStore.send(.view(.onTapMMinusButton))} label: { Text("m-") }
        Button {viewStore.send(.view(.onTapMRButton))} label: { Text("mr") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button {viewStore.send(.view(.onTapACButton))} label: { Text("AC") }
        Button { viewStore.send(.view(.onTapNegateSignButton))} label: {Image(systemName: "plus.forwardslash.minus") }
        Button {viewStore.send(.view(.onTapPercentButton))} label: { Text("%") }
      }.buttonStyle(self.grayStyle)
      Button {viewStore.send(.view(.onTapDivideButton))} label: { 
        self.withCircleBackground(bool: viewStore.isDivideOn, color: viewStore.userSelectedColor) {
          Image(systemName: "divide") }
        }
    }
  }
  
  func row2(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button { viewStore.send(.view(.onTapSecondButton))} label: { Text("2") + Text("nd".attributed().superscripted()) }
        Button { viewStore.send(.view(.onTapSquaredButton ))} label: { Text("x".attributed() + "2".attributed().superscripted()) }
        Button { viewStore.send(.view(.onTapCubedButton)) } label: { Text("x".attributed() + "3".attributed().superscripted()) }
        Button { viewStore.send(.view(.onTapXToThePowerOfYButton)) } label: { Text("x".attributed() + "y".attributed().superscripted()) }
        Button {viewStore.send(.view(.onTapEToThePowerOfXButton))} label: { Text("e".attributed() + "x".attributed().superscripted()) }
        Button { viewStore.send(.view(.onTap10ToThePowerOfXButton))} label: { Text("10".attributed() + "x".attributed().superscripted()) }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 7)))} label: { Text("7") }
        Button { viewStore.send(.view(.onTap(int: 8)))} label: { Text("8") }
        Button { viewStore.send(.view(.onTap(int: 9)))} label: { Text("9") }
      }.buttonStyle(self.midgrayStyle)
      Button { viewStore.send(.view(.onTapMultiplyButton))} label: { 
        self.withCircleBackground(bool: viewStore.isMultiplyOn, color: viewStore.userSelectedColor) {
          Image(systemName: "multiply") }
      }
    }
  }
  
  func row3(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button { viewStore.send(.view(.onTap1OverXButton)) } label: { Text("1/x") }
        Button {viewStore.send(.view(.onTapSquareRootButton))} label: { Text("2".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button {viewStore.send(.view(.onTapCubeRootButton))} label: { Text("3".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button {viewStore.send(.view(.onTapYRootXButton))} label: { Text("y".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
        Button { viewStore.send(.view(.onTapLNButton))} label: { Text("ln") }
        Button {viewStore.send(.view(.onTapLogSub10))} label: { Text("log") + Text("10".attributed().subscripted()) }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 4)))} label: { Text("4") }
        Button { viewStore.send(.view(.onTap(int: 5)))} label: { Text("5") }
        Button { viewStore.send(.view(.onTap(int: 6)))} label: { Text("6") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapMinusButton))} label: { 
        self.withCircleBackground(bool: viewStore.isMinusOn, color: viewStore.userSelectedColor) {
          Image(systemName: "minus") }
      }
    }
  }
  
  func row4(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {viewStore.send(.view(.onTapFactorialButton))} label: { Text("x!") }
        Button {viewStore.send(.view(.onTapSinButton))} label: { Text("sin") }
        Button {viewStore.send(.view(.onTapCosButton))} label: { Text("cos") }
        Button {viewStore.send(.view(.onTapTanButton))} label: { Text("tan") }
        Button {viewStore.send(.view(.onTapEButton))} label: { Text("e") }
        Button {viewStore.send(.view(.onTapEEButton))} label: { Text("EE") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 1)))} label: { Text("1") }
        Button { viewStore.send(.view(.onTap(int: 2)))} label: { Text("2") }
        Button { viewStore.send(.view(.onTap(int: 3)))} label: { Text("3") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapPlusButton))} label: { 
        self.withCircleBackground(bool: viewStore.isPlusOn, color: viewStore.userSelectedColor) {
          Image(systemName: "plus") }
      }
    }
  }
  
  func row5(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {viewStore.send(.view(.onTapRadButton))} label: { Text("Rad") }
        Button {viewStore.send(.view(.onTapSinHButton))} label: { Text("sinh") }
        Button {viewStore.send(.view(.onTapCosHButton))} label: { Text("cosh") }
        Button {viewStore.send(.view(.onTapTanHButton))} label: { Text("tanh") }
        Button {viewStore.send(.view(.onTapPiButton))} label: { Text("π") }
        Button { viewStore.send(.view(.onTapRandButton))} label: { Text("Rand") }
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 0)))} label: { Text("0") }
          .gridCellColumns(2)
        
        Button(".") { viewStore.send(.view(.onTapDecimalButton)) }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapEqualButton))} label: { 
        Image(systemName: "equal") }
          .modifier(self.offTintBackground(viewStore.userSelectedColor))
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
