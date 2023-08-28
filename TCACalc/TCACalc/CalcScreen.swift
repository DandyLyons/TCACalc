//
//  CalcScreen.swift
//  TCACalc
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import ComposableArchitecture





struct CalcScreenFeature: Reducer {
  struct State: Equatable {
    var calculation: CalculationReducer.State
    
    var hScreen: CalcScreenHFeature.State
    var vScreen: CalcScreenVFeature.State
    @PresentationState var presentation: Presentation.State?
    
    var currentOrientation: UIDeviceOrientation
    var userSettings: UserSettings
    
//    private(set) var activeOperation: ActiveOperation? = nil
//    enum ActiveOperation: String { case divide, multiply, minus, plus }
    
    /// to mutate `currentNum` use `updateCurrentNum(byPerforming: )`
//    private(set) var currentNum: Decimal = 0
    
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
//      activeOperation: ActiveOperation? = nil,
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
//      self.activeOperation = activeOperation
//      self.currentNum = currentNum
//      self.previousNum = previousNum
//      self.isInBlankState = isInBlankState
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
    
    // TODO: Fix this
//    mutating func onTap(int: Int) {
//      switch (self.isInBlankState, self.activeOperation) {
//        case (true, .some):
//          self.updateCurrentNum(byPerforming: { $0.append(int)})
//        case (false, .some):
//          self.previousNum = self.currentNum
//          self.updateCurrentNum(byPerforming: { $0 = Decimal(int) })
//        case (true, .none):
//          self.updateCurrentNum(byPerforming: { $0.append(int)})
//        case (false, .none):
//          self.updateCurrentNum(byPerforming: { $0.append(int)})
//      }
//    }
    
//    mutating func onTapACButton() {
//      self.updateCurrentNum(byPerforming: { $0 = 0})
//      self.previousNum = nil
//      self.updateIsInBlankState(byPerforming: { $0 = true })
//      self.updateActiveOperation(to: nil)
//    }
    
    mutating func onTapPercentButton() {
      
    }
    
    mutating func onTapNegateSignButton() {
//      self.updateCurrentNum(byPerforming: { $0 *= -1 })
    }
//    mutating func onTapDivideButton() {
//      self.updateActiveOperation(to: .divide)
//    }
//    mutating func onTapMultiplyButton() {
//      self.updateActiveOperation(to: .multiply)
//    }
//    mutating func onTapMinusButton() {
//      self.updateActiveOperation(to: .minus)
//    }
//    mutating func onTapPlusButton() {
//      self.updateActiveOperation(to: .plus)
//    }
//    mutating func onTapEqualButton() {
//      self._performArithmetic()
//      self.updateActiveOperation(to: nil)
//    }
    
    
    
//    mutating func updateCurrentNum(byPerforming mutation: (inout Decimal) -> Void) {
//      mutation(&self.currentNum)
//      mutation(&self.hScreen.currentNum)
//      mutation(&self.vScreen.currentNum)
//    }
    
//    mutating func updateActiveOperation(to newValue: ActiveOperation?) {
//      switch newValue {
//        case .divide:
//          self.hScreen.calcGridH.turnDivideOn()
//          self.vScreen.calcGridV.turnDivideOn()
//        case .multiply:
//          self.hScreen.calcGridH.turnMultiplyOn()
//          self.vScreen.calcGridV.turnMultiplyOn()
//        case .minus:
//          self.hScreen.calcGridH.turnMinusOn()
//          self.vScreen.calcGridV.turnMinusOn()
//        case .plus:
//          self.hScreen.calcGridH.turnPlusOn()
//          self.vScreen.calcGridV.turnPlusOn()
//        case nil:
//          self.hScreen.calcGridH.turnAllOff()
//          self.vScreen.calcGridV.turnAllOff()
//      }
//      self.activeOperation = newValue
//    }
    
//    mutating func _performArithmetic() {
//      guard let activeOperation,
//            let previousNum else {
//        return
//      }
//      let result: Decimal
//      
//      switch activeOperation {
//          
//        case .divide:
//          result = previousNum / self.currentNum
//        case .multiply:
//          result = previousNum * self.currentNum
//        case .minus:
//          result = previousNum - self.currentNum
//        case .plus:
//          result = previousNum + self.currentNum
//      }
//      self.previousNum = self.currentNum
//      self.updateCurrentNum(byPerforming: { $0 = result})
//    }
    
//    var previousNum: Decimal? = nil
//    private(set) var isInBlankState: Bool = true
//    
//    mutating func determineIfInBlankState () {
//      if self.currentNum == 0,
//         self.previousNum == nil {
//        self.updateIsInBlankState(byPerforming: { $0 = true })
//      } else {
//        self.updateIsInBlankState(byPerforming: { $0 = false })
//      }
//    }
    
//    mutating func updateIsInBlankState(byPerforming mutation: (inout Bool) -> Void) {
//      mutation(&self.isInBlankState)
//      mutation(&self.vScreen.calcGridV.isInBlankState)
//      mutation(&self.hScreen.calcGridH.isInBlankState)
//    }
    
//    mutating func updateIsInBlankState(to newValue: Bool) {
//      self.isInBlankState = newValue
//      self.vScreen.calcGridV.isInBlankState = newValue
//      self.hScreen.calcGridH.isInBlankState = newValue
//    }
    
  }
  enum Action: Equatable {
    case calculation(CalculationReducer.Action)
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
//                  state.onTap(int: int)
                  return .run { await $0(.calculation(.input(.int(int))))}
                case .view(.onTapACButton):
//                  state.onTapACButton()
                  return .run { await $0(.calculation(.input(.reset))) }
                case .view(.onTapPercentButton):
                  return .run { await $0(.calculation(.input(.toPercent))) }
                case .view(.onTapNegateSignButton):
//                  state.onTapNegateSignButton()
                  return .none
                  
                case .view(.onTapDivideButton):
//                  state.onTapDivideButton()
                  return .run { await $0(.calculation(.input(.operation(.divide)))) }
                case .view(.onTapMultiplyButton):
//                  state.onTapMultiplyButton()
                  return .run { await $0(.calculation(.input(.operation(.multiply)))) }
                case .view(.onTapMinusButton):
//                  state.onTapMinusButton()
                  return .run { await $0(.calculation(.input(.operation(.minus)))) }
                case .view(.onTapPlusButton):
//                  state.onTapPlusButton()
                  return .run { await $0(.calculation(.input(.operation(.plus)))) }
                  
                case .view(.onTapEqualButton):
//                  state.onTapEqualButton()
                  return .run { await $0(.calculation(.input(.equals))) }
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
//                  state.onTap(int: int)
                  return .run { await $0(.calculation(.input(.int(int)))) }
                case .view(.onTapACButton):
                  return .run { await $0(.calculation(.input(.reset))) }
                  
                case .view(.onTapPercentButton):
                  return .run { await $0(.calculation(.input(.toPercent))) }
                case .view(.onTapNegateSignButton):
//                  state.onTapNegateSignButton()
                  return .none
                  
                case .view(.onTapDivideButton):
                  return .run { await $0(.calculation(.input(.operation(.divide)))) }
                  
                case .view(.onTapMultiplyButton):
//                  state.onTapMultiplyButton()
                  return .run { await $0(.calculation(.input(.operation(.multiply)))) }
                case .view(.onTapMinusButton):
//                  state.onTapMinusButton()
                  return .run { await $0(.calculation(.input(.operation(.minus)))) }
                case .view(.onTapPlusButton):
//                  state.onTapPlusButton()
                  return .run { await $0(.calculation(.input(.operation(.plus)))) }
                  
                case .view(.onTapEqualButton):
//                  state.onTapEqualButton()
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
                      state.vScreen.currentNum = "Not Yet Implemented"
                      state.hScreen.currentNum = "Not Yet Implemented"
                      return .none
                  }
              }
            case .delegate(let hCalcScreenDelegateAction):
              switch hCalcScreenDelegateAction {
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
                    case .accentColorChanged(let newValue):
                      state.userSettings.accentColor = newValue
                      state.hScreen.calcGridH.userSelectedColor = newValue
                      state.vScreen.calcGridV.userSelectedColor = newValue
                      return .none
                  }
              }
            case .alert(let alerts):
              switch alerts {
                case .numberFact:
                  return .none
              }
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
      CalcScreenHFeature()
    }
    Scope(state: \.vScreen, action: /Action.vScreen) {
      CalcScreenVFeature()
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
      enum Alert { case numberFact }
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

// MARK: View
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
    let isInBlankState: Bool
    
    let currentTintColor: Color
    let calculationState: CalculationReducer.State
    
    init(state: CalcScreenFeature.State) {
      #if os(iOS)
      self.currentOrientation = state.currentOrientation
      #endif
      
      self.calculationState = state.calculation
      
      self.colorSchemeMode = state.userSettings.colorSchemeMode
      self.isDebugModeOn = state.userSettings.isDebugModeOn

      self.isInBlankState = state.calculation.status == .initial
      self.currentTintColor = state.userSettings.accentColor
    }
  }
  
  @ViewBuilder
  func vDebugView(_ viewStore: ViewStoreOf_CalcScreen) -> some View {
    VStack(alignment: .trailing) {
      Text("isInBlankState: \(viewStore.isInBlankState.description)")
      Divider()
      Text("Current orientation: \(viewStore.currentOrientation.debugDescription)")
      Divider()
      Text("Calculation State: \(viewStore.calculationState.debugDescription)")
      VStack(alignment: .leading) {
        Text("State: \(viewStore.calculationState.status.rawValue)")
        Text("num1: \(viewStore.calculationState.num1.formatted())")
        Text("op1: \(viewStore.calculationState.op1?.rawValue ?? "")")
        Text("num2: \(viewStore.calculationState.num2.formatted())")
        Text("op2: \(viewStore.calculationState.op2?.rawValue ?? "")")
        Text("num3: \(viewStore.calculationState.num3.formatted())")
      }.frame(maxWidth: .infinity, alignment: .leading)
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
      // MARK: View Events
      .onAppear {
        viewStore.send(.currentOrientationChangedTo(UIDeviceOrientation.portrait))
      }
      .onRotate { newOrientation in
        viewStore.send(.currentOrientationChangedTo(newOrientation))
      }
      
      // MARK: View Styling
      .preferredColorScheme(viewStore.colorSchemeMode.resolvedColorScheme)
      .tint(viewStore.currentTintColor)
      
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
        }
      )
      .alert(store: self.store.scope(state: \.$presentation, action: { .presentation($0)}),
             state: /CalcScreenFeature.Presentation.State.alert,
             action: CalcScreenFeature.Presentation.Action.alert
      )
      
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

extension AlertState where Action == CalcScreenFeature.Presentation.Action.Alert {
  static func alert_numberFact(_ fact: String) -> Self {
    return Self {
      TextState(fact)
    } actions: {
      ButtonState(role: .none, label: { TextState("Ok")})
    }
  }
  
  static func alert_numberFactError_NotWholeNumber() -> Self {
    return Self {
      TextState("Cannot get a number fact for non-whole numbers.")
    }
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
