//
//  CalcScreen.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture

struct Presentation: Reducer {
  enum State: Equatable {
    case settings(SettingsReducer.State)
  }
  enum Action: Equatable {
    case settings(SettingsReducer.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: /State.settings, action: /Action.settings) {
      SettingsReducer()
    }
  }
}

struct CalcScreenFeature: Reducer {
  struct State: Equatable {
    var hScreen: CalcScreenHFeature.State
    var vScreen: CalcScreenVFeature.State
    @PresentationState var presentation: Presentation.State?
    
    var currentOrientation: UIDeviceOrientation
    var userSettings: UserSettings
    
    private(set) var activeOperation: ActiveOperation? = nil
    enum ActiveOperation: String { case divide, multiply, minus, plus }
    
    /// to mutate `currentNum` use `updateCurrentNum(byPerforming: )`
    private(set) var currentNum: Decimal = 0
    
    // MARK: CalcScreenFeature.init
    /// Creates new State for CalcScreenFeature
    /// - Parameters:
    ///   - hScreen: state of the subview shown when horizontal
    ///   - vScreen: state of the subview shown when vertival
    ///   - presentation: the views that can be presented by CalcScreen
    ///   - currentOrientation: the current device orientation
    ///   - colorSchemeMode: Leave nil if you'd like to use the value from UserDefaults (which defaults to .auto)
    ///   - activeOperation: the active calculator operation
    ///   - currentNum: the current number
    ///   - previousNum: the previous number
    ///   - isInBlankState: whether the calculator is currently in a blank state
    init(
      hScreen: CalcScreenHFeature.State,
      vScreen: CalcScreenVFeature.State,
      presentation: Presentation.State? = nil,
      currentOrientation: UIDeviceOrientation,
      userSettings: UserSettings,
      activeOperation: ActiveOperation? = nil,
      currentNum: Decimal = 0,
      previousNum: Decimal? = nil,
      isInBlankState: Bool = true
    ) {
      self.hScreen = hScreen
      self.vScreen = vScreen
      self.presentation = presentation
      self.currentOrientation = currentOrientation
      self.userSettings = userSettings
      self.activeOperation = activeOperation
      self.currentNum = currentNum
      self.previousNum = previousNum
      self.isInBlankState = isInBlankState
    }
    
    // TODO: Fix this
    mutating func onTap(int: Int) {
      switch (self.isInBlankState, self.activeOperation) {
        case (true, .some):
          self.updateCurrentNum(byPerforming: { $0.append(int)})
        case (false, .some):
          self.previousNum = self.currentNum
          self.updateCurrentNum(byPerforming: { $0 = Decimal(int) })
        case (true, .none):
          self.updateCurrentNum(byPerforming: { $0.append(int)})
        case (false, .none):
          self.updateCurrentNum(byPerforming: { $0.append(int)})
      }
    }
    
    mutating func onTapACButton() {
      self.updateCurrentNum(byPerforming: { $0 = 0})
      self.previousNum = nil
      self.updateIsInBlankState(byPerforming: { $0 = true })
      self.updateActiveOperation(to: nil)
    }
    
    mutating func onTapPercentButton() {
      self.updateCurrentNum(byPerforming: { $0 /= 100 })
    }
    
    mutating func onTapNegateSignButton() {
      self.updateCurrentNum(byPerforming: { $0 *= -1 })
    }
    mutating func onTapDivideButton() {
      self.updateActiveOperation(to: .divide)
    }
    mutating func onTapMultiplyButton() {
      self.updateActiveOperation(to: .multiply)
    }
    mutating func onTapMinusButton() {
      self.updateActiveOperation(to: .minus)
    }
    mutating func onTapPlusButton() {
      self.updateActiveOperation(to: .plus)
    }
    mutating func onTapEqualButton() {
      self._performArithmetic()
      self.updateActiveOperation(to: nil)
    }
    
    
    
    mutating func updateCurrentNum(byPerforming mutation: (inout Decimal) -> Void) {
      mutation(&self.currentNum)
      mutation(&self.hScreen.currentNum)
      mutation(&self.vScreen.currentNum)
    }
    
    mutating func updateActiveOperation(to newValue: ActiveOperation?) {
      switch newValue {
        case .divide:
          self.hScreen.calcGridH.turnDivideOn()
          self.vScreen.calcGridV.turnDivideOn()
        case .multiply:
          self.hScreen.calcGridH.turnMultiplyOn()
          self.vScreen.calcGridV.turnMultiplyOn()
        case .minus:
          self.hScreen.calcGridH.turnMinusOn()
          self.vScreen.calcGridV.turnMinusOn()
        case .plus:
          self.hScreen.calcGridH.turnPlusOn()
          self.vScreen.calcGridV.turnPlusOn()
        case nil:
          self.hScreen.calcGridH.turnAllOff()
          self.vScreen.calcGridV.turnAllOff()
      }
      self.activeOperation = newValue
    }
    
    mutating func _performArithmetic() {
      guard let activeOperation,
            let previousNum else {
        return
      }
      let result: Decimal
      
      switch activeOperation {
          
        case .divide:
          result = previousNum / self.currentNum
        case .multiply:
          result = previousNum * self.currentNum
        case .minus:
          result = previousNum - self.currentNum
        case .plus:
          result = previousNum + self.currentNum
      }
      self.previousNum = self.currentNum
      self.updateCurrentNum(byPerforming: { $0 = result})
    }
    
    var previousNum: Decimal? = nil
    private(set) var isInBlankState: Bool = true
    
    mutating func determineIfInBlankState () {
      if self.currentNum == 0,
         self.previousNum == nil {
        self.updateIsInBlankState(byPerforming: { $0 = true })
      } else {
        self.updateIsInBlankState(byPerforming: { $0 = false })
      }
    }
    
    mutating func updateIsInBlankState(byPerforming mutation: (inout Bool) -> Void) {
      mutation(&self.isInBlankState)
      mutation(&self.vScreen.calcGridV.isInBlankState)
      mutation(&self.hScreen.calcGridH.isInBlankState)
    }
    
    mutating func updateIsInBlankState(to newValue: Bool) {
      self.isInBlankState = newValue
      self.vScreen.calcGridV.isInBlankState = newValue
      self.hScreen.calcGridH.isInBlankState = newValue
    }
    
  }
  enum Action: Equatable {
    //    case internalAction
    
    case hScreen(CalcScreenHFeature.Action)
    case vScreen(CalcScreenVFeature.Action)
    
    case currentOrientationChangedTo(UIDeviceOrientation)
    
    case view(View)
    enum View: Equatable {
      //      case viewAction
    }
    case delegate(Delegate)
    enum Delegate: Equatable {
      //      case delegateAction
    }
    case presentation(PresentationAction<Presentation.Action>)
    
  }
  
  
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case let .currentOrientationChangedTo(newOrientation):
          state.currentOrientation = newOrientation
          return .none
          
          // SPYING ON SUBVIEWS
        case .vScreen(let vScreenAction):
          switch vScreenAction {
            case .view: return .none
            case .delegate(let vScreenDelegateAction):
              switch vScreenDelegateAction {
                case .presentSettingsView:
                  state.presentation = .settings(.init(state.userSettings))
                  return .none
              }
              
            case .calcGridV(let vCalcGridAction):
              switch vCalcGridAction {
                case .view(.onTap(int: let int)):
                  state.onTap(int: int)
                  return .none
                case .view(.onTapACButton):
                  state.onTapACButton()
                  return .none
                case .view(.onTapPercentButton):
                  state.onTapPercentButton()
                  return .none
                case .view(.onTapNegateSignButton):
                  state.onTapNegateSignButton()
                  return .none
                  
                case .view(.onTapDivideButton):
                  state.onTapDivideButton()
                  return .none
                case .view(.onTapMultiplyButton):
                  state.onTapMultiplyButton()
                  return .none
                case .view(.onTapMinusButton):
                  state.onTapMinusButton()
                  return .none
                case .view(.onTapPlusButton):
                  state.onTapPlusButton()
                  return .none
                  
                case .view(.onTapEqualButton):
                  state.onTapEqualButton()
                  return .none
                case .view(.onTapDecimalButton):
                  return .none
              }
          }
          
        case .hScreen(let hScreenAction):
          switch hScreenAction {
            case .view: return .none
              
            case .calcGridH(let hCalcGridAction):
              switch hCalcGridAction {
                case .view(.onTap(int: let int)):
                  state.onTap(int: int)
                  return .none
                case .view(.onTapACButton):
                  state.onTapACButton()
                  return .none
                case .view(.onTapPercentButton):
                  state.onTapPercentButton()
                  return .none
                case .view(.onTapNegateSignButton):
                  state.onTapNegateSignButton()
                  return .none
                  
                case .view(.onTapDivideButton):
                  state.onTapDivideButton()
                  return .none
                case .view(.onTapMultiplyButton):
                  state.onTapMultiplyButton()
                  return .none
                case .view(.onTapMinusButton):
                  state.onTapMinusButton()
                  return .none
                case .view(.onTapPlusButton):
                  state.onTapPlusButton()
                  return .none
                  
                case .view(.onTapEqualButton):
                  state.onTapEqualButton()
                  return .none
                  
                case .view(.onTapDecimalButton):
                  return .none
              }
            case .delegate(let hCalcGridDelegateAction):
              switch hCalcGridDelegateAction {
                case .presentSettingsView:
                  state.presentation = .settings(.init(state.userSettings))
                  return .none
              }
          }
          
        // MARK: Presented Views
        case let .presentation(.presented(presentedView)):
          switch presentedView {
              // MARK: Settings
            case .settings(let settingsAction):
              switch settingsAction {
                case ._internal, .binding, .view: return .none
                  
                case .delegate(let settingsDelegateActions):
                  switch settingsDelegateActions {
                    case .colorSchemeModeChanged(let newColorSchemeMode):
                      state.userSettings.colorSchemeMode = newColorSchemeMode
                      return .none
                    case .isDebugModeOnChanged(let newValue):
                      state.userSettings.isDebugModeOn = newValue
                      return .none
                  }
              }
          }
          
        case .presentation(.dismiss):
          return .none
      }
    }
    Reduce<State, Action> { state, action in
      state.determineIfInBlankState()
      return .none
    }
    .ifLet(\.$presentation, action: /Action.presentation) {
      Self.Presentation()
    }
    
    
    Scope(state: \.hScreen, action: /Action.hScreen) {
      CalcScreenHFeature()
    }
    Scope(state: \.vScreen, action: /Action.vScreen) {
      CalcScreenVFeature()
    }
  }
  
  struct Presentation: Reducer {
    enum State: Equatable {
      case settings(SettingsReducer.State)
    }
    enum Action: Equatable {
      case settings(SettingsReducer.Action)
    }
    var body: some ReducerOf<Self> {
      Scope(state: /State.settings, action: /Action.settings) {
        SettingsReducer()
      }
    }
  }
  
}

extension UIDeviceOrientation: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
      case .unknown: "unknown"
      case .portrait: "portrait"
      case .portraitUpsideDown: "portrait upside down"
      case .landscapeLeft: "landscape left"
      case .landscapeRight: "landscape right"
      case .faceUp: "face up"
      case .faceDown: "face down"
      @unknown default: "unknown default"
    }
  }
}

import SwiftUI

struct CalcScreen: View {
  typealias ViewStoreOf_CalcScreen = ViewStore<ViewState, CalcScreenFeature.Action>
  let store: StoreOf<CalcScreenFeature>
//  @State private var currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
  
  
  struct ViewState: Equatable {
    #if os(iOS)
    let currentOrientation: UIDeviceOrientation
    #endif
    
    let colorSchemeMode: ColorSchemeMode
    let isDebugModeOn: Bool
    let previousNum: Decimal?
    let isInBlankState: Bool
    let activeOperation: CalcScreenFeature.State.ActiveOperation?
    
    init(state: CalcScreenFeature.State) {
      #if os(iOS)
      self.currentOrientation = state.currentOrientation
      #endif
      
      self.colorSchemeMode = state.userSettings.colorSchemeMode
      self.isDebugModeOn = state.userSettings.isDebugModeOn
      self.previousNum = state.previousNum
      self.isInBlankState = state.isInBlankState
      self.activeOperation = state.activeOperation
      
    }
  }
  
  @ViewBuilder
  func vDebugView(_ viewStore: ViewStoreOf_CalcScreen) -> some View {
    VStack(alignment: .trailing) {
      Text("Prev num: \(viewStore.previousNum?.customDumpDescription ?? "none")")
      Text("isInBlankState: \(viewStore.isInBlankState.description)")
      Text("Active Operation: \(viewStore.activeOperation?.rawValue ?? "none")")
      Divider()
      Text("Current orientation: \(viewStore.currentOrientation.debugDescription)")
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Group {
        switch viewStore.currentOrientation {
          case .portrait, .portraitUpsideDown,.faceDown, .faceUp:
            self.vScreen
              .overlay(alignment: .topTrailing) {
                if viewStore.isDebugModeOn { self.vDebugView(viewStore).padding(.trailing) }
              }
          case .landscapeLeft, .landscapeRight:
            self.hScreen
          case .unknown:
            // TODO: Delete this
            self.vScreen
              .onAppear { print("Something is broken") }
            
          @unknown default:
            self.vScreen
              .onAppear { print("Something is broken") }
        }
      }
      .onAppear {
        viewStore.send(.currentOrientationChangedTo(UIDeviceOrientation.portrait))
      }
      .onRotate { newOrientation in
        viewStore.send(.currentOrientationChangedTo(newOrientation))
      }
      .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
      
      // MARK: View Presentation
      .sheet(
        store: self.store.scope(state: \.$presentation, action: { .presentation($0) }),
        state: /CalcScreenFeature.Presentation.State.settings,
        action: CalcScreenFeature.Presentation.Action.settings,
        onDismiss: nil,
        content: { settingsStore in
          NavigationStack {
            SettingsView(store: settingsStore)
              .navigationTitle("Settings")
              .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
          }
        })
      
    }
  }
  
  var vScreen: some View {
    CalcScreenVertical(
      store: self.store.scope(
        state: \.vScreen,
        action: CalcScreenFeature.Action.vScreen
      )
    )
  }
  
  var hScreen: some View {
    CalcScreenHorizontal(
      store: self.store.scope(
        state: \.hScreen,
        action: CalcScreenFeature.Action.hScreen
      )
    )
  }
  
}

//#Preview("CalcScreen H"
//         , traits: .landscapeLeft
//) {
//  CalcScreen(store: .init(initialState: .init(hScreen: .init(calcGridH: .init()),
//                                              vScreen: .init(calcGridV: .init()),
//                                              currentOrientation: .landscapeLeft
//                                             ),
//                          reducer: {
//    CalcScreenFeature()._printChanges()
//  }))
//}

#Preview("CalcScreen V"
) {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(calcGridH: .init()),
        vScreen: .init(calcGridV: .init()),
        currentOrientation: .portrait,
        userSettings: .init(isDebugModeOn: true)
      ),
      reducer: {
    CalcScreenFeature()._printChanges()
  }))
}
