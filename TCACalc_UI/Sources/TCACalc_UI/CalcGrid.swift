//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/13/23.
//

import Foundation
import SwiftUI

import ComposableArchitecture

public struct CalcGridFeature: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    var isDivideOn = false
    var isMultiplyOn = false
    var isMinusOn = false
    var isPlusOn = false
    
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
          }
          
        case .delegate:
          return .none
      }
    }
  }
}

public struct CalcGrid: View {
  let store: StoreOf<CalcGridFeature>
  
  public init(store: StoreOf<CalcGridFeature>) {
    self.store = store
  }
  
  public let grayStyle = CircleButtonStyle(foregroundIdleColor: .black, backgroundIdleColor: .gray)
  public let darkgrayStyle = CircleButtonStyle(foregroundIdleColor: .white, backgroundIdleColor: .secondary)
  
  public let onOrangeBackground = CircleBackground(foreground: .orange, background: .white)
  public let offOrangeBackground = CircleBackground(foreground: .white, background: .orange)
  
    
  public var body: some View {
    WithViewStore(self.store, observe: { $0 } ) { viewStore in
      
      
      Grid(alignment: .center, horizontalSpacing: 10.0, verticalSpacing: 10.0) {
        GridRow {
          Button("AC") {}
            .buttonStyle(self.grayStyle)
          Button {} label: { Image(systemName: "plus.forwardslash.minus")}
            .buttonStyle(self.grayStyle)
          Button("%") {}
            .buttonStyle(self.grayStyle)
          Button { viewStore.send(.view(.onTapDivideButton)) } label: {
            Image(systemName: "divide")
              .modifier(viewStore.isDivideOn ? self.onOrangeBackground : self.offOrangeBackground)
          }
        }
        GridRow {
          Button("7") {}
            .buttonStyle(self.darkgrayStyle)
          Button("8") {}
            .buttonStyle(self.darkgrayStyle)
          Button("9") {}
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapMultiplyButton)) } label: {
            Image(systemName: "multiply")
              .modifier(viewStore.isMultiplyOn ? self.onOrangeBackground : self.offOrangeBackground)
          }
        }
        GridRow {
          Button("4") {}
            .buttonStyle(self.darkgrayStyle)
          Button("5") {}
            .buttonStyle(self.darkgrayStyle)
          Button("6") {}
            .buttonStyle(self.darkgrayStyle)
          
          Button { viewStore.send(.view(.onTapMinusButton)) } label: {
            Image(systemName: "minus")
              .modifier(viewStore.isMinusOn ? self.onOrangeBackground : self.offOrangeBackground)
          }
          
          
          
        }
        GridRow {
          Button("1") {}
            .buttonStyle(self.darkgrayStyle)
          Button("2") {}
            .buttonStyle(self.darkgrayStyle)
          Button("3") {}
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapPlusButton)) } label: {
            Image(systemName: "plus")
              .modifier(viewStore.isPlusOn ? self.onOrangeBackground : self.offOrangeBackground)
          }
        }
        GridRow {
          Button {} label: { Text("0").foregroundStyle(.white)}
            .gridCellColumns(2)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background { Capsule().foregroundColor(.secondary) }
          
          
          Button(".") {}
            .buttonStyle(self.darkgrayStyle)
          Button { viewStore.send(.view(.onTapEqualButton)) } label: {
            Image(systemName: "equal")
              .modifier(self.offOrangeBackground)
          }
        }
        .frame(maxHeight: 90)
      }
      .font(.title)
      .fontWeight(.bold)
      
    }
  }
}

public struct CircleBackground: ViewModifier {
  public let foreground: Color
  public let background: Color
  
  public func body(content: Content) -> some View {
    ZStack {
      Circle()
        .foregroundColor(self.background)
      
      content
        .foregroundColor(self.foreground)
    }
  }
}

#Preview {
  ZStack {
    Color.black
      .ignoresSafeArea()
    VStack {
      Spacer()
      
      CalcGrid(store: Store(initialState: .init(), reducer: {
        CalcGridFeature()._printChanges()
      }))
    }
    .padding(.horizontal)
  }
  
}
