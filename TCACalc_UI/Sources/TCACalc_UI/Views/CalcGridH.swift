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
    public var currentOperation: Operation?
    public var isInBlankState = true
    public enum Operation: Equatable {
      case divide, multiply, minus, plus
    }
    
    public init(
      currentOperation: Operation? = nil,
      isInBlankState: Bool = true
    ) {
      self.currentOperation = currentOperation
      self.isInBlankState = isInBlankState
    }
    
    public var isDivideOn: Bool { self.currentOperation == .divide }
    public var isMultiplyOn: Bool { self.currentOperation == .multiply }
    public var isMinusOn: Bool { self.currentOperation == .minus }
    public var isPlusOn: Bool { self.currentOperation == .plus }
  }
  public enum Action: Equatable {
    
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
              return .none
            case .onTapMultiplyButton:
              return .none
            case .onTapMinusButton:
              return .none
            case .onTapPlusButton:
              return .none
            case .onTapEqualButton:
              return .none
            case .onTap(int: _):
              return .none
            case .onTapACButton:
              return .none
            case .onTapNegateSignButton:
              return .none
            case .onTapPercentButton:
              return .none
            case .onTapDecimalButton:
              return .none
              
            
            case .onTapSquaredButton, .onTapCubedButton, .onTapXToThePowerOfYButton, .onTap10ToThePowerOfXButton, .onTap1OverXButton, .onTapOpenParenthesesButton, .onTapCloseParenthesesButton, .onTapMCButton, .onTapMPlusButton, .onTapMMinusButton, .onTapMRButton, .onTap2ndButton, .onTapEToThePowerOfXButton, .onTapCubeRootButton, .onTapYRootXButton, .onTapLNButton, .onTapLogSub10, .onTapFactorialButton, .onTapSinButton, .onTapCosButton, .onTapTanButton, .onTapEButton, .onTapEEButton, .onTapRadButton, .onTapSinHButton, .onTapCosHButton, .onTapTanHButton, .onTapPiButton, .onTapRandButton, .onTapSecondButton, .onTapSquareRootButton:
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
    
    init(state: CalcGridHFeature.State) {
      self.isDivideOn = state.isDivideOn
      self.isMultiplyOn = state.isMultiplyOn
      self.isMinusOn = state.isMinusOn
      self.isPlusOn = state.isPlusOn
      self.isInBlankState = state.isInBlankState
    }
  }
  
  @Environment(\.userSelectedColor) var userSelectedColor
  
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
          .accessibilityLabel(Text("Open Parentheses"))
        Button {viewStore.send(.view(.onTapCloseParenthesesButton))} label: { Text(")") }
          .accessibilityLabel(Text("Close Parentheses"))
        Button {viewStore.send(.view(.onTapMCButton))} label: { Text("mc") }
          .accessibilityLabel(Text("Memory Clear"))
        Button {viewStore.send(.view(.onTapMPlusButton))} label: { Text("m+") }
          .accessibilityLabel(Text("Memory Add"))
        Button {viewStore.send(.view(.onTapMMinusButton))} label: { Text("m-") }
          .accessibilityLabel(Text("Memory Subtract"))
        Button {viewStore.send(.view(.onTapMRButton))} label: { Text("mr") }
          .accessibilityLabel(Text("Memory Recall"))
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button {viewStore.send(.view(.onTapACButton))} label: { Text(viewStore.isInBlankState ? "AC" : "C") }
          .accessibilityLabel(Text(viewStore.isInBlankState ? "All Clear" : "Clear")) 
        Button { viewStore.send(.view(.onTapNegateSignButton))} label: {Image(systemName: "plus.forwardslash.minus") }
          .accessibilityLabel(Text("Negative"))
        Button {viewStore.send(.view(.onTapPercentButton))} label: { Text("%") }
      }.buttonStyle(self.grayStyle)
      Button {viewStore.send(.view(.onTapDivideButton))} label: { 
        self.withCircleBackground(bool: viewStore.isDivideOn, color: userSelectedColor) {
          Image(systemName: "divide") }
        }
    }
  }
  
  func row2(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button { viewStore.send(.view(.onTapSecondButton))} label: { Text("2") + Text("nd".attributed().superscripted()) }
          .accessibilityLabel(Text("Alternative Trigonometry Functions"))
        Button { viewStore.send(.view(.onTapSquaredButton ))} label: { Text("x".attributed() + "2".attributed().superscripted()) }
          .accessibilityLabel(Text("Squared"))
        Button { viewStore.send(.view(.onTapCubedButton)) } label: { Text("x".attributed() + "3".attributed().superscripted()) }
          .accessibilityLabel(Text("Cubed"))
        Button { viewStore.send(.view(.onTapXToThePowerOfYButton)) } label: { Text("x".attributed() + "y".attributed().superscripted()) }
          .accessibilityLabel(Text("Power"))
        Button {viewStore.send(.view(.onTapEToThePowerOfXButton))} label: { Text("e".attributed() + "x".attributed().superscripted()) }
          .accessibilityLabel(Text("Exponential"))
        Button { viewStore.send(.view(.onTap10ToThePowerOfXButton))} label: { Text("10".attributed() + "x".attributed().superscripted()) }
          .accessibilityLabel(Text("10 to the power of"))
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 7)))} label: { Text("7") }
        Button { viewStore.send(.view(.onTap(int: 8)))} label: { Text("8") }
        Button { viewStore.send(.view(.onTap(int: 9)))} label: { Text("9") }
      }.buttonStyle(self.midgrayStyle)
      Button { viewStore.send(.view(.onTapMultiplyButton))} label: { 
        self.withCircleBackground(bool: viewStore.isMultiplyOn, color: userSelectedColor) {
          Image(systemName: "multiply") }
      }
    }
  }
  
  func row3(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button { viewStore.send(.view(.onTap1OverXButton)) } label: { Text("1/x") }
          .accessibilityLabel(Text("Reciprocal"))
        Button {viewStore.send(.view(.onTapSquareRootButton))} label: { Text("2".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
          .accessibilityLabel(Text("Square Root"))
        Button {viewStore.send(.view(.onTapCubeRootButton))} label: { Text("3".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
          .accessibilityLabel(Text("Cube Root"))
        Button {viewStore.send(.view(.onTapYRootXButton))} label: { Text("y".attributed().superscripted()) + Text(Image(systemName: "x.squareroot")) }
          .accessibilityLabel(Text("Root"))
        Button { viewStore.send(.view(.onTapLNButton))} label: { Text("ln") }
          .accessibilityLabel(Text("Natural Log"))
        Button {viewStore.send(.view(.onTapLogSub10))} label: { Text("log") + Text("10".attributed().subscripted()) }
          .accessibilityLabel(Text("Log Base 10"))
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 4)))} label: { Text("4") }
        Button { viewStore.send(.view(.onTap(int: 5)))} label: { Text("5") }
        Button { viewStore.send(.view(.onTap(int: 6)))} label: { Text("6") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapMinusButton))} label: { 
        self.withCircleBackground(bool: viewStore.isMinusOn, color: userSelectedColor) {
          Image(systemName: "minus") }
      }
    }
  }
  
  func row4(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {viewStore.send(.view(.onTapFactorialButton))} label: { Text("x!") }
          .accessibilityLabel(Text("Factorial"))
        Button {viewStore.send(.view(.onTapSinButton))} label: { Text("sin") }
          .accessibilityLabel(Text("Sine"))
        Button {viewStore.send(.view(.onTapCosButton))} label: { Text("cos") }
          .accessibilityLabel(Text("Cosine"))
        Button {viewStore.send(.view(.onTapTanButton))} label: { Text("tan") }
          .accessibilityLabel(Text("Tangent"))
        Button {viewStore.send(.view(.onTapEButton))} label: { Text("e") }
          .accessibilityLabel(Text("Euler's Number"))
        Button {viewStore.send(.view(.onTapEEButton))} label: { Text("EE") }
          .accessibilityLabel(Text("EE"))
          .accessibilityHint(Text("Engineering Exponent"))
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 1)))} label: { Text("1") }
        Button { viewStore.send(.view(.onTap(int: 2)))} label: { Text("2") }
        Button { viewStore.send(.view(.onTap(int: 3)))} label: { Text("3") }
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapPlusButton))} label: { 
        self.withCircleBackground(bool: viewStore.isPlusOn, color: userSelectedColor) {
          Image(systemName: "plus") }
      }
    }
  }
  
  func row5(_ viewStore: ViewStore<CalcGridH.ViewState, CalcGridHFeature.Action>) -> some View {
    GridRow {
      Group {
        Button {viewStore.send(.view(.onTapRadButton))} label: { Text("Rad") }
          .accessibilityLabel(Text("Radians"))
        Button {viewStore.send(.view(.onTapSinHButton))} label: { Text("sinh") }
          .accessibilityLabel(Text("Hyperbolic Sine"))
        Button {viewStore.send(.view(.onTapCosHButton))} label: { Text("cosh") }
          .accessibilityLabel(Text("Hyberbolic Cosine"))
        Button {viewStore.send(.view(.onTapTanHButton))} label: { Text("tanh") }
          .accessibilityLabel(Text("Hyberbolic Tangent"))
        Button {viewStore.send(.view(.onTapPiButton))} label: { Text("π") }
          .accessibilityLabel(Text("Pi"))
        Button { viewStore.send(.view(.onTapRandButton))} label: { Text("Rand") }
          .accessibilityLabel(Text("Random Number"))
      }
      .buttonStyle(self.darkgrayStyle)
      Group {
        Button { viewStore.send(.view(.onTap(int: 0)))} label: { Text("0") }
          .gridCellColumns(2)
        
        Button(".") { viewStore.send(.view(.onTapDecimalButton)) }
          .accessibilityLabel(Text("Decimal"))
      }.buttonStyle(self.midgrayStyle)
      Button {viewStore.send(.view(.onTapEqualButton))} label: { 
        Image(systemName: "equal") }
          .modifier(self.offTintBackground(userSelectedColor))
    }
  }
  
  
}



#Preview("CalcGridH", traits: .landscapeLeft
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
