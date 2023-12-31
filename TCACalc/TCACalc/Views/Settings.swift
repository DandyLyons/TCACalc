//
//  Settings.swift
//  TCACalc
//
//  Created by Daniel Lyons on 8/17/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import DependenciesAdditions
import PlusNightMode



/// The Reducer for the `SettingsView`
struct SettingsReducer: Reducer {
  /// The State for the `SettingsReducer`
  struct State: Equatable {
    @BindingState var userSettings: UserSettings
    @PresentationState var presentation: Presentation.State?
    var showingExampleNightMode = false
    @BindingState var isExampleNightModePresented: Bool = false
    
    init(_ userSettings: UserSettings = .init(),
         presentation: Presentation.State? = nil
    ) {
      self.userSettings = userSettings
      self.presentation = presentation
    }
      
  }
  /// The Action for the `SettingsReducer`
  enum Action: Equatable, BindableAction {
    case view(ViewAction)
    case delegate(DelegateAction)
    case _internal(InternalAction)
    case binding(BindingAction<State>)
    case presentation(PresentationAction<Presentation.Action>)
    
    enum DelegateAction: Equatable {
      case colorSchemeModeChanged(ColorSchemeMode)
      case isDebugModeOnChanged(Bool)
      case userSettingsChanged(UserSettings)
    }
    enum InternalAction: Equatable {
      case showError(ShowError)
      enum ShowError { case saveError }
      case isExampleNightModePresented(Bool)
    }
    enum ViewAction: Equatable {
      case onTapDoneButton
    }
    
    /// Use this Action if you explicitly want this Action to be ignored
    /// Useful for when you want to create an inert binding
    case none
    
  }
  
  struct Presentation: Reducer {
    enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case exampleNightMode
    }
    
    enum Action: Equatable {
      case alert(Alert)
      enum Alert: Equatable {
        case saveError
      }
    }
    
    var body: some ReducerOf<SettingsReducer.Presentation> {
      Reduce<State, Action> { state, action in
        switch action {
          case .alert(let alertAction):
            switch alertAction {
              case .saveError: return .none
            }
        }
      }
    }
  }
  
  // MARK: Dependencies
   @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.userSettings) { oldValue, newValue in
        Reduce<State, Action> { _, _ in
          @Dependency(\.logger) var logger
          logger.notice("UserSettings did change in SettingsReducer.State. Saving now.")
          @Dependency(\.userSettings.save) var saveUserSettings
          do {
            try saveUserSettings(newValue)
          } catch {
            logger.warning("UserSettings failed to save.")
            return .send(._internal(.showError(.saveError)))
          }
          return .send(.delegate(.userSettingsChanged(newValue)))
        }
      }
      
    
    Reduce<State, Action> { state, action in
      switch action {
          
        case .delegate, .binding, .presentation:
          return .none
          
        case .view(let viewAction):
          switch viewAction {
            case .onTapDoneButton:
              return .run { send in await self.dismiss() }
          }
          
        case ._internal(let _internalAction):
          switch _internalAction {
            case .showError(let showError):
              switch showError {
                case .saveError:
                  state.presentation = .alert(.alert_saveError())
                  return .none
              }
            case .isExampleNightModePresented(let newValue):
              state.isExampleNightModePresented = newValue
              return .none
          }
        case .none: return .none
      }
    }
    .ifLet(\.$presentation, action: /Action.presentation) {
      Self.Presentation()
    }
  }
}

struct SettingsView: View {
  let store: StoreOf<SettingsReducer>
  
  struct ViewState: Equatable {
    @BindingViewState var userSettings: UserSettings
    var showingExampleNightMode: Bool
    @BindingViewState var isExampleNightModePresented: Bool
    
    
    
    /// Create a ViewState for SettingsView using a BindingViewStore
    /// - Parameter bindingViewStore: For use with @BindingState
    ///
    /// - ViewState allows our ViewStore to observe only the the State necessary for rendering the View.
    /// - The BindingReducer allows TCA to make SwiftUI Bindings automatically for us.
    /// - And BindingViewStore ensures compatibility between our ViewState and our BindingReducer.
    init(bindingViewStore: BindingViewStore<SettingsReducer.State>) {
      self._userSettings = bindingViewStore.$userSettings
      self.showingExampleNightMode = bindingViewStore.showingExampleNightMode
      self._isExampleNightModePresented = bindingViewStore.$isExampleNightModePresented
    }
  }
  
  @ViewBuilder
  /// The Picker View for Light/Dark/Night mode
  /// - Parameters:
  ///   - style: the type of Picker you would like to show
  ///   - viewStore: the ViewStore for TCA communication
  /// - Returns: the Picker View
  func appearancePicker(
    style: some PickerStyle,
    _ viewStore: ViewStore<ViewState, SettingsReducer.Action>
  ) -> some View {
    Picker("Appearance", selection: viewStore.$userSettings.colorSchemeMode) {
      ForEach(ColorSchemeMode.allCases) { colorSchemeMode in
        Text(colorSchemeMode.localizedString)
          .tag(colorSchemeMode)
      }
    }
    .pickerStyle(style)
    .tint(viewStore.state.userSettings.accentColor)
  }
  
  @Environment(\.colorSchemeMode) var colorSchemeMode
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Form {
        Section("Appearance") {
          self.appearancePicker(style: .segmented, viewStore)
          
          ColorPicker("Accent Color", selection: viewStore.$userSettings.accentColor)
            .disabled(viewStore.userSettings.colorSchemeMode == .night)
        }
        Section {
          Toggle("Debug Mode", isOn: viewStore.$userSettings.isDebugModeOn)
          #if DEBUG
          Button("Example night Mode View", action: { viewStore.send(._internal(.isExampleNightModePresented(true)))}
          )
          #endif
          
        } header: {
          Text("🪲 Debugging")
        } footer: {
          Text("Debugging labels are only visible in portrait orientation.")
        }
        
        
        Section("Info") {
          Link(destination: URL(string: "https://github.com/DandyLyons/TCACalc")!) {
            Text("See the GitHub repo")
          }
        }
      }
      .tint(colorSchemeMode == .night ? .red :   viewStore.userSettings.accentColor)
      .toolbar {
        Button("Done") { viewStore.send(.view(.onTapDoneButton))}
      }
      
      // View Presentation
      .alert(store: self.store.scope(state: \.$presentation, action: { .presentation($0)}),
             state: /SettingsReducer.Presentation.State.alert,
             action: SettingsReducer.Presentation.Action.alert
      )
      #if DEBUG
      .sheet(isPresented: viewStore.$isExampleNightModePresented) {
        ExampleNightModeView()
      }
      #endif

    }
  }
}

// MARK: Previews
#Preview("SettingsView: presented") {
  CalcScreen(
    store: .init(
      initialState: .init(
        hScreen: .init(currentNum: "0", calcGridH: .init()),
        vScreen: .init(currentNum: "0", calcGridV: .init()),
        presentation: .settings(.init(.init(colorSchemeMode: .night))),
        userSettings: .init(colorSchemeMode: .night, accentColor: .blue)
        
      )) {
        CalcScreenReducer()
      }
  )
//  .environment(\.colorSchemeMode, .light)
}

extension AlertState where Action == SettingsReducer.Presentation.Action.Alert {
  static func alert_saveError() -> Self {
    return Self {
      TextState("There was an error while saving your UserSettings.")
    }
  }
}
