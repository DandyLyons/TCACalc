//
//  CalcGridV.swift
//
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import SwiftUI

import ComposableArchitecture

public struct CalcGridVFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    var isDivideOn: Bool { self.currentOperation == .divide }
    var isMultiplyOn: Bool { self.currentOperation == .multiply }
    var isMinusOn: Bool { self.currentOperation == .minus }
    var isPlusOn: Bool { self.currentOperation == .plus }
    public var isInBlankState = true
    public var currentOperation: Operation?
    public enum Operation: Equatable {
      case divide, multiply, minus, plus
    }
    
    public var userSelectedColor: Color = .green
    
    public init(currentOperation: Operation? = nil, isInBlankState: Bool = true) {
      self.currentOperation = currentOperation
      self.isInBlankState = isInBlankState
    }
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
              return .none
            case .onTapMultiplyButton:
              return .none
            case .onTapMinusButton:
              return .none
            case .onTapPlusButton:
              return .none
            case .onTapEqualButton:
              return .none
            case .onTap:
              return .none
            case .onTapACButton:
              state.isInBlankState = true
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

public struct CalcGridV: View {
  let store: StoreOf<CalcGridVFeature>
  @Environment(\.colorScheme) var colorScheme
  
  public init(store: StoreOf<CalcGridVFeature>) {
    self.store = store
  }
  
  public let grayStyle = CircleButtonStyle(foregroundIdleColor: .black, backgroundIdleColor: .gray)
  public let darkgrayStyle = CircleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary)
  
  @ViewBuilder
  func withCircleBackground(bool: Bool, color: Color, _ content: () -> some View) -> some View {
    
    content()
      .if(bool) {
        $0.modifier(self.onTintBackground(color, withBorder: self.colorScheme == .light))
      } else: {
        $0.modifier(self.offTintBackground(color))
      }
  }
  
  public func onTintBackground(_ color: Color, withBorder isBordered: Bool = false) -> CircleBackground {
    CircleBackground(foreground: color, background: .white, backgroundBordered: isBordered)
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
    
    init(state: CalcGridVFeature.State) {
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
        GridRow {
          Button(viewStore.isInBlankState ? "AC" : "C") { viewStore.send(.view(.onTapACButton)) }
            .buttonStyle(self.grayStyle)
          Button { viewStore.send(.view(.onTapNegateSignButton))} label: { Image(systemName: "plus.forwardslash.minus")}
            .buttonStyle(self.grayStyle)
          Button("%") { viewStore.send(.view(.onTapPercentButton)) }
            .buttonStyle(self.grayStyle)
          Button { viewStore.send(.view(.onTapDivideButton)) } label: {
            self.withCircleBackground(bool: viewStore.isDivideOn, color: viewStore.userSelectedColor) {
              Image(systemName: "divide")
            }
            .shouldBorder(bool: self.colorScheme == .light, viewStore.userSelectedColor)
          }
        }
        GridRow {
          Button("7") { viewStore.send(.view(.onTap(int: 7))) }
            .buttonStyle(self.darkgrayStyle)
          Button("8") { viewStore.send(.view(.onTap(int: 8))) }
            .buttonStyle(self.darkgrayStyle)
          Button("9") { viewStore.send(.view(.onTap(int: 9))) }
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapMultiplyButton)) } label: {
            self.withCircleBackground(bool: viewStore.isMultiplyOn, color: viewStore.userSelectedColor) {
              Image(systemName: "multiply")
              
            }
          }
        }
        GridRow {
          Button("4") { viewStore.send(.view(.onTap(int: 4))) }
            .buttonStyle(self.darkgrayStyle)
          Button("5") { viewStore.send(.view(.onTap(int: 5))) }
            .buttonStyle(self.darkgrayStyle)
          Button("6") { viewStore.send(.view(.onTap(int: 6))) }
            .buttonStyle(self.darkgrayStyle)
          
          Button { viewStore.send(.view(.onTapMinusButton)) } label: {
            self.withCircleBackground(bool: viewStore.isMinusOn, color: viewStore.userSelectedColor) {
              Image(systemName: "minus")
              
            }
          }
        }
        GridRow {
          Button("1") { viewStore.send(.view(.onTap(int: 1))) }
            .buttonStyle(self.darkgrayStyle)
          Button("2") { viewStore.send(.view(.onTap(int: 2))) }
            .buttonStyle(self.darkgrayStyle)
          Button("3") { viewStore.send(.view(.onTap(int: 3))) }
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapPlusButton)) } label: {
            self.withCircleBackground(bool: viewStore.isPlusOn, color: viewStore.userSelectedColor) {
              Image(systemName: "plus")
              
            }
          }
        }
        GridRow {
          Button {
            viewStore.send(.view(.onTap(int: 0)))
          } label: {
            Text("0")
          }
            .gridCellColumns(2)
            .gridCellUnsizedAxes([.vertical, .horizontal])
            .buttonStyle(CapsuleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary))
          
          
          Button(".") { viewStore.send(.view(.onTapDecimalButton))}
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapEqualButton)) } label: {
            Image(systemName: "equal")
              .modifier(self.offTintBackground(viewStore.userSelectedColor))
          }
        }
      }
      .font(.title)
      .fontWeight(.bold)
      
    }
  }
}

extension View {
  /// Applies the given transform if the given condition evaluates to `true`.
  /// - Parameters:
  ///   - condition: The condition to evaluate.
  ///   - transform: The transform to apply to the source `View`.
  /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
  @ViewBuilder func `if`<Content: View>(
    _ condition: Bool,
    then thenTransform: (Self) -> Content,
    else elseTransform: ((Self) -> Content)?
  ) -> some View {
    if condition {
      thenTransform(self)
    } else {
      if let elseTransform {
        elseTransform(self)
      } else {
        self
      }
    }
  }
}



#Preview("CalcGridV"
) {
  ZStack {
    Color.black
      .ignoresSafeArea()
    VStack {
      Spacer()
      
      CalcGridV(store: Store(initialState: .init(), reducer: {
        CalcGridVFeature()._printChanges()
      }))
    }
    .padding(.horizontal)
  }
  
}

extension View {
  @ViewBuilder
  func shouldBorder(bool: Bool, _ content: some ShapeStyle) -> some View {
    if bool {
      self
        .border(content)
    } else {
      self
    }
  }
}