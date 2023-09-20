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


struct SettingsReducer: Reducer {
  struct State: Equatable {
    @BindingState var userSettings: UserSettings
    
    init(_ userSettings: UserSettings = .init()) {
      self.userSettings = userSettings
    }
      
  }
  enum Action: Equatable, BindableAction {
    case view(ViewAction)
    case delegate(DelegateAction)
    case _internal(InternalAction)
    case binding(BindingAction<State>)
    
    enum DelegateAction: Equatable {
      case colorSchemeModeChanged(ColorSchemeMode)
      case isDebugModeOnChanged(Bool)
      case accentColorChanged(Color)
      case userSettingsChanged(UserSettings)
    }
    enum InternalAction: Equatable {
      
    }
    enum ViewAction: Equatable {
      case onTapDoneButton
    }
    
  }
  
  // MARK: Dependencies
   @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
          
        case .delegate, .binding:
          return .none
          
        case .view(let viewAction):
          switch viewAction {
            case .onTapDoneButton:
              return .run { send in await self.dismiss() }
          }
      }
    }
    BindingReducer()
      .onChange(of: \.userSettings) { oldValue, newValue in
        Reduce<State, Action> { state, action in
          @Dependency(\.encode) var encode
          @Dependency(\.userDefaults) var userDefaults
          
          let data: Data? = try? encode(newValue)
          userDefaults.set(data, forKey: UserDefaults.key_userSettings)
          return .send(.delegate(.userSettingsChanged(newValue)))
        }
      }
  }
}

struct SettingsView: View {
  let store: StoreOf<SettingsReducer>
  
  struct ViewState: Equatable {
    @BindingViewState var userSettings: UserSettings
    
    init(bindingViewStore: BindingViewStore<SettingsReducer.State>) {
      self._userSettings = bindingViewStore.$userSettings
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      Form {
        Section("Appearance") {
          Picker("Appearance", selection: viewStore.$userSettings.colorSchemeMode) {
            ForEach(ColorSchemeMode.allCases) { colorSchemeMode in
              Text(colorSchemeMode.localizedString)
                .tag(colorSchemeMode)
                .observingNightMode(true)
            }
            .observingNightMode(true)
          }
          
          ColorPicker("Accent Color", selection: viewStore.$userSettings.accentColor)
            .disabled(viewStore.userSettings.colorSchemeMode == .night)
        }
        Section {
          Toggle("Debug Mode", isOn: viewStore.$userSettings.isDebugModeOn)
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
      .preferredColorScheme(viewStore.userSettings.colorSchemeMode.resolvedColorScheme)
      .toolbar {
        Button("Done") { viewStore.send(.view(.onTapDoneButton))}
      }
    }
  }
}

// MARK: Previews
#Preview("SettingsView") {
  let store = StoreOf<SettingsReducer>(
    initialState: SettingsReducer.State(),
    reducer: {
      SettingsReducer()
        ._printChanges()
    }
  )
  
  return SettingsView(store: store)
}
