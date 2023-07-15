//
//  CalcGridV.swift
//
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import SwiftUI

import ComposableArchitecture

public struct CalcGridVFeature: ReducerProtocol {
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
    
    mutating func turnDivideOn() {
      self.isDivideOn = true
      self.isMultiplyOn = false
      self.isMinusOn = false
      self.isPlusOn = false
    }
    mutating func turnMultiplyOn() {
      self.isDivideOn = false
      self.isMultiplyOn = true
      self.isMinusOn = false
      self.isPlusOn = false
    }
    mutating func turnMinusOn() {
      self.isDivideOn = false
      self.isMultiplyOn = false
      self.isMinusOn = true
      self.isPlusOn = false
    }
    mutating func turnPlusOn() {
      self.isDivideOn = false
      self.isMultiplyOn = false
      self.isMinusOn = false
      self.isPlusOn = true
    }
    mutating func turnAllOff() {
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
    }
    case delegate(Delegate)
    public enum Delegate: Equatable {
      
    }
    
    
  }
  
  public var body: some ReducerProtocolOf<Self> {
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
          }
          
        case .delegate:
          return .none
      }
    }
  }
}

public struct CalcGridV: View {
  let store: StoreOf<CalcGridVFeature>
  
  public init(store: StoreOf<CalcGridVFeature>) {
    self.store = store
  }
  
  public let grayStyle = CircleButtonStyle(foregroundIdleColor: .black, backgroundIdleColor: .gray)
  public let darkgrayStyle = CircleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary)
  
  public let onOrangeBackground = CircleBackground(foreground: .orange, background: .white)
  public let offOrangeBackground = CircleBackground(foreground: .white, background: .orange)
  
  
  
    
  public var body: some View {
    WithViewStore(self.store, observe: { $0 } ) { viewStore in
      
      
      Grid(alignment: .center, horizontalSpacing: 8.0, verticalSpacing: 8.0) {
        GridRow {
          Button(viewStore.isInBlankState ? "AC" : "C") { viewStore.send(.view(.onTapACButton)) }
            .buttonStyle(self.grayStyle)
          Button { viewStore.send(.view(.onTapNegateSignButton))} label: { Image(systemName: "plus.forwardslash.minus")}
            .buttonStyle(self.grayStyle)
          Button("%") { viewStore.send(.view(.onTapPercentButton)) }
            .buttonStyle(self.grayStyle)
          Button { viewStore.send(.view(.onTapDivideButton)) } label: {
            Image(systemName: "divide")
              .modifier(viewStore.isDivideOn ? self.onOrangeBackground : self.offOrangeBackground)
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
            Image(systemName: "multiply")
              .modifier(viewStore.isMultiplyOn ? self.onOrangeBackground : self.offOrangeBackground)
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
            Image(systemName: "minus")
              .modifier(viewStore.isMinusOn ? self.onOrangeBackground : self.offOrangeBackground)
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
            Image(systemName: "plus")
              .modifier(viewStore.isPlusOn ? self.onOrangeBackground : self.offOrangeBackground)
          }
        }
        GridRow {
          Button { viewStore.send(.view(.onTap(int: 0)))} label: { Text("0").foregroundStyle(.white)}
            .frame(maxHeight: .infinity)
            .gridCellColumns(2)
            .gridCellUnsizedAxes(.vertical)
            .frame(maxWidth: .infinity)
            .background { Capsule().foregroundColor(.secondary) }
          
          
          Button(".") {}
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapEqualButton)) } label: {
            Image(systemName: "equal")
              .modifier(self.offOrangeBackground)
          }
        }
        
      }
      .font(.title)
      .fontWeight(.bold)
      
    }
  }
}



#Preview("CalcGridV"
//        , traits: .none
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
