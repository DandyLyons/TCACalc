//
//  SettingsTests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 9/14/23.
//

import XCTest
@testable import TCACalc
import ComposableArchitecture
import PlusNightMode
import SwiftUI

@MainActor
final class SettingsTests: XCTestCase {
  
  
  func testAppearance() async {
    var userSettings: UserSettings = .init(
      isDebugModeOn: false,
      colorSchemeMode: .light,
      accentColor: .green
    )
    
    let store = TestStore(
      initialState: SettingsReducer.State(userSettings),
      reducer: {
        SettingsReducer()
      },
      withDependencies: {
        $0.decode = .json
        $0.encode = .json
      }
    )
    
    userSettings.colorSchemeMode = .dark
    await store.send(.set(\.$userSettings, userSettings)) {
      $0.userSettings.colorSchemeMode = .dark
    }
    await store.receive(.delegate(.userSettingsChanged(userSettings)))
    
    userSettings.colorSchemeMode = .night
    await store.send(.set(\.$userSettings, userSettings)) {
      $0.userSettings.colorSchemeMode = .night
    }
    await store.receive(.delegate(.userSettingsChanged(userSettings)))
    XCTAssertEqual(userSettings.colorSchemeMode.resolvedColorScheme, ColorScheme.dark)
    
  }
  
  func testAccentColor() async {
    var userSettings: UserSettings = .init(
      isDebugModeOn: false,
      colorSchemeMode: .light,
      accentColor: .green
    )
    
    let store = TestStore(
      initialState: SettingsReducer.State(userSettings),
      reducer: {
        SettingsReducer()
      },
      withDependencies: {
        $0.decode = .json
        $0.encode = .json
      }
    )
    
    userSettings.accentColor = .red
    await store.send(.set(\.$userSettings, userSettings)) {
      $0.userSettings.accentColor = .red
    }
    await store.receive(.delegate(.userSettingsChanged(userSettings)))
  }

}
