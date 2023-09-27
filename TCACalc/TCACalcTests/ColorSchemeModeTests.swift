//
//  ColorSchemeModeTests.swift
//  TCACalcTests
//
//  Created by Daniel Lyons on 9/25/23.
//

import XCTest
import SnapshotTesting
import TCACalc_UI
import SwiftUI
@testable import TCACalc
import PlusNightMode
import Dependencies


final class PlusNightModeTests: XCTestCase {
  
  
  func testCalcScreenNightMode() {
    var view = CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init(colorSchemeMode: .night, accentColor: .blue)
        )) {
          CalcScreenReducer()._printChanges()
        }
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      record: false
    )
  }
  
  func testCalcScreenDarkMode() {    var view = CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init(colorSchemeMode: .dark, accentColor: .blue)
        )) {
          CalcScreenReducer()._printChanges()
        }
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      record: false
    )
  }
  
  func testCalcScreenLightMode() {
    var view = CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init(colorSchemeMode: .light, accentColor: .blue)
        )) {
          CalcScreenReducer()._printChanges()
        }
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .dark)
      ),
      record: false
    )
  }
  
  func testCalcScreenAutoMode() {
    var view = CalcScreen(
      store: .init(
        initialState: .init(
          hScreen: .init(currentNum: "0", calcGridH: .init()),
          vScreen: .init(currentNum: "0", calcGridV: .init()),
          userSettings: .init(colorSchemeMode: .auto, accentColor: .blue)
        )) {
          CalcScreenReducer()._printChanges()
        }
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      named: "CalcScreen_Auto_Light",
      record: true
    )
    assertSnapshot(
      of: view,
      as: .wait(for: 0.5, on: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .dark)
      )),
      named: "CalcScreen_Auto_Dark",
      record: true
    )
  }
  
  func testSettingsNightMode() {
    
    var view = SettingsView(
      store: .init(
        initialState: .init(
          UserSettings(
            colorSchemeMode: .night,
            accentColor: .blue
          )
        ),
        reducer: {
          SettingsReducer()
        })
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      record: true
    )
  }
  
  func testSettingsDarkMode() {
    var view = SettingsView(
      store: .init(
        initialState: .init(
          UserSettings(
            colorSchemeMode: .dark,
            accentColor: .blue
          )
        ),
        reducer: {
          SettingsReducer()
        })
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      record: true
    )
  }
  
  func testSettingsLightMode() {

    var view = SettingsView(
      store: .init(
        initialState: .init(
          UserSettings(
            colorSchemeMode: .night,
            accentColor: .blue
          )
        ),
        reducer: {
          SettingsReducer()
        })
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .dark)
      ),
      record: true
    )
  }
  
  func testSettingsAutoMode() {
    
    var view = SettingsView(
      store: .init(
        initialState: .init(
          UserSettings(
            colorSchemeMode: .auto,
            accentColor: .blue
          )
        ),
        reducer: {
          SettingsReducer()
        })
    )
    
    assertSnapshot(
      of: view,
      as: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .light)
      ),
      named: "Settings_Auto_Light",
      record: false
    )
    assertSnapshot(
      of: view,
      as: .wait(for: 0.5, on: .image(
        drawHierarchyInKeyWindow: true,
        perceptualPrecision: 0.98,
        layout: .device(config: .iPhone13Pro),
        traits: .init(userInterfaceStyle: .dark)
      )),
      named: "Settings_Auto_Dark",
      record: false
    )
  }
}
private let referenceSize = CGSize(width: 1170, height: 2532)

private extension SwiftUI.View {
  
  func referenceFrame() -> some View {
    self.frame(width: referenceSize.width, height: referenceSize.height)
  }
}
