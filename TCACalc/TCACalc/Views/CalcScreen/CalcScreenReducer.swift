//
//  CalcScreen.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI




struct CalcScreenReducer: Reducer {
  struct State: Equatable {
    var calculation: CalculationReducer.State
    
    var hScreen: CalcScreenHReducer.State
    var vScreen: CalcScreenVReducer.State
    @PresentationState var presentation: Presentation.State?
    
    var currentOrientation: UIDeviceOrientation
    var userSettings: UserSettings
    
    // MARK: CalcScreenReducer.init
    /// Creates new State for CalcScreenReducer
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
      hScreen: CalcScreenHReducer.State,
      vScreen: CalcScreenVReducer.State,
      presentation: Presentation.State? = nil,
      currentOrientation: UIDeviceOrientation,
      userSettings: UserSettings,
      currentNum: Decimal = 0,
      previousNum: Decimal? = nil,
      isInBlankState: Bool = true
    ) {
      self.calculation = .init()
      self.hScreen = hScreen
      self.vScreen = vScreen
      self.presentation = presentation
      self.currentOrientation = currentOrientation
      self.userSettings = userSettings
    }
    
    mutating func calculationReducerDidUpdate() {
      self.hScreen.currentNum = self.calculation.displayString
      self.vScreen.currentNum = self.calculation.displayString
      switch self.calculation.op_resolved {
        case .plus:
          self.vScreen.calcGridV.currentOperation = .plus
        case .minus:
          self.vScreen.calcGridV.currentOperation = .minus
        case .multiply:
          self.vScreen.calcGridV.currentOperation = .multiply
        case .divide:
          self.vScreen.calcGridV.currentOperation = .divide
        case .none:
          self.vScreen.calcGridV.currentOperation = .none
      }
      
      // determine if AC Button should show AC or C
      let shouldShowAC = self.calculation.status == .initial
      self.vScreen.calcGridV.isInBlankState = shouldShowAC
      self.hScreen.calcGridH.isInBlankState = shouldShowAC
      
    }
    
  }
  enum Action: Equatable {
    case calculation(CalculationReducer.Action)
    //    case internalAction
    
    case hScreen(CalcScreenHReducer.Action)
    case vScreen(CalcScreenVReducer.Action)
    
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
    
    case factResponse(String)
  }
  
  // MARK: Dependencies
  @Dependency(\.numberFact) var numberFact
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case .calculation(.delegate(let calculationDelegateAction)):
          switch calculationDelegateAction {
            case .didFinishCalculating:
              state.calculationReducerDidUpdate()
              return .none
          }
        case .calculation: return .none
          
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
                case .numDisplayTapped:
                  if state.userSettings.isDebugModeOn {
                    state.calculation = .init() // force calculation engine to reset
                    state.vScreen = .init(currentNum: "0", calcGridV: .init())
                    state.hScreen = .init(currentNum: "0", calcGridH: .init())
                  } else {
                    if let decimal = state.calculation.num_resolved {
                      if decimal.isWholeNumber {
                        let number = Int(truncatingIfNeeded: decimal)
                        return .run { send in
                          try await send(.factResponse(numberFact.fetch(number)))
                        }
                      } else {
                        state.presentation = .alert(.alert_numberFactError_NotWholeNumber())
                      }
                    }
                  }
                  return .none
              }
              
            case .calcGridV(let vCalcGridAction):
              switch vCalcGridAction {
                case .view(.onTap(int: let int)):
                  return .run { await $0(.calculation(.input(.int(int))))}
                case .view(.onTapACButton):
                  return .run { await $0(.calculation(.input(.reset))) }
                case .view(.onTapPercentButton):
                  return .run { await $0(.calculation(.input(.toPercent))) }
                case .view(.onTapNegateSignButton):
                  return .run { await $0(.calculation(.input(.negate)))}
                  
                case .view(.onTapDivideButton):
                  return .run { await $0(.calculation(.input(.operation(.divide)))) }
                case .view(.onTapMultiplyButton):
                  return .run { await $0(.calculation(.input(.operation(.multiply)))) }
                case .view(.onTapMinusButton):
                  return .run { await $0(.calculation(.input(.operation(.minus)))) }
                case .view(.onTapPlusButton):
                  return .run { await $0(.calculation(.input(.operation(.plus)))) }
                case .view(.onTapEqualButton):
                  return .run { await $0(.calculation(.input(.equals))) }
                case .view(.onTapDecimalButton):
                  return .run { await $0(.calculation(.input(.decimal))) }
              }
          }
          
        case .hScreen(let hScreenAction):
          switch hScreenAction {
            case .view: return .none
              
            case .calcGridH(let hCalcGridAction):
              switch hCalcGridAction {
                case .view(.onTap(int: let int)):
//                  state.onTap(int: int)
                  return .run { await $0(.calculation(.input(.int(int)))) }
                case .view(.onTapACButton):
                  return .run { await $0(.calculation(.input(.reset))) }
                  
                case .view(.onTapPercentButton):
                  return .run { await $0(.calculation(.input(.toPercent))) }
                case .view(.onTapNegateSignButton):
                  return .run { await $0(.calculation(.input(.negate)))}
                  
                case .view(.onTapDivideButton):
                  return .run { await $0(.calculation(.input(.operation(.divide)))) }
                  
                case .view(.onTapMultiplyButton):
                  return .run { await $0(.calculation(.input(.operation(.multiply)))) }
                case .view(.onTapMinusButton):
                  return .run { await $0(.calculation(.input(.operation(.minus)))) }
                case .view(.onTapPlusButton):
                  return .run { await $0(.calculation(.input(.operation(.plus)))) }
                  
                case .view(.onTapEqualButton):
                  return .run { await $0(.calculation(.input(.equals))) }
                  
                case .view(.onTapDecimalButton):
                  return .run { await $0(.calculation(.input(.decimal))) }
                case .view(.onTapSquaredButton):
                  return .none
                case .view(.onTapCubedButton):
                  return .none
                case .view(.onTapXToThePowerOfYButton):
                  return .none
                case .view(.onTap10ToThePowerOfXButton):
                  return .none
                case .view(.onTap1OverXButton):
                  return .none
                case .view(.onTapOpenParenthesesButton):
                  return .none
                case .view(.onTapCloseParenthesesButton):
                  return .none
                case .view(.onTapMCButton):
                  return .none
                case .view(.onTapMPlusButton):
                  return .none
                case .view(.onTapMMinusButton):
                  return .none
                case .view(.onTapMRButton):
                  return .none
                case .view(.onTap2ndButton):
                  return .none
                case .view(.onTapEToThePowerOfXButton):
                  return .none
                case .view(.onTapSquareRootButton):
                  return .none
                case .view(.onTapCubeRootButton):
                  return .none
                case .view(.onTapYRootXButton):
                  return .none
                case .view(.onTapLNButton):
                  return .none
                  case .view(.onTapLogSub10):
                  return .none
                case .view(.onTapFactorialButton):
                  return .none
                case .view(.onTapSinButton):
                  return .none
                case .view(.onTapCosButton):
                  return .none
                case .view(.onTapTanButton):
                  return .none
                case .view(.onTapEButton):
                  return .none
                case .view(.onTapEEButton):
                  return .none
                case .view(.onTapRadButton):
                  return .none
                case .view(.onTapSinHButton):
                  return .none
                case .view(.onTapCosHButton):
                  return .none
                case .view(.onTapTanHButton):
                  return .none
                case .view(.onTapPiButton):
                  return .none
                case .view(.onTapRandButton):
                  return .none
                case .view(.onTapSecondButton):
                  return .none
                case .delegate(let hCalcGridDelegateActions):
                  switch hCalcGridDelegateActions {
                    case .notYetImplemented:
                      state.presentation = .alert(.alert_notYetImplemented())
                      return .none
                  }
              }
            case .delegate(let hCalcScreenDelegateAction):
              switch hCalcScreenDelegateAction {
                case .presentSettingsView:
                  state.presentation = .settings(.init(state.userSettings))
                  return .none
                  
                case .numDisplayTapped:
                  if state.userSettings.isDebugModeOn {
                    state.calculation = .init() // force calculation engine to reset
                    state.vScreen = .init(currentNum: "0", calcGridV: .init())
                    state.hScreen = .init(currentNum: "0", calcGridH: .init())
                  } else {
                    if let decimal = state.calculation.num_resolved {
                      if decimal.isWholeNumber {
                        let number = Int(truncatingIfNeeded: decimal)
                        return .run { send in
                          try await send(.factResponse(numberFact.fetch(number)))
                        }
                      } else {
                        state.presentation = .alert(.alert_numberFactError_NotWholeNumber())
                      }
                    }
                  }
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
                    case .accentColorChanged(let newValue):
                      state.userSettings.accentColor = newValue
                      state.hScreen.calcGridH.userSelectedColor = newValue
                      state.vScreen.calcGridV.userSelectedColor = newValue
                      return .none
                    case .userSettingsChanged(let newValue):
                      state.userSettings = newValue
                      state.hScreen.calcGridH.userSelectedColor = newValue.accentColor
                      state.vScreen.calcGridV.userSelectedColor = newValue.accentColor
                      return .none
                      
                  }
              }
            case .alert: return .none
          }
          
        case .presentation(.dismiss):
          return .none
        
        case .factResponse(let fact):
          state.presentation = .alert(.alert_numberFact(fact))
          return .none
      }
    }
    .ifLet(\.$presentation, action: /Action.presentation) {
      Self.Presentation()
    }
    Scope(state: \.calculation, action: /Action.calculation) {
      CalculationReducer()
    }
    Scope(state: \.hScreen, action: /Action.hScreen) {
      CalcScreenHReducer()
    }
    Scope(state: \.vScreen, action: /Action.vScreen) {
      CalcScreenVReducer()
    }
  }
  
  struct Presentation: Reducer {
    enum State: Equatable {
      case settings(SettingsReducer.State)
      case alert(AlertState<Action.Alert>)
    }
    enum Action: Equatable {
      case settings(SettingsReducer.Action)
      case alert(Alert)
      enum Alert { case numberFact, notYetImplemented }
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
