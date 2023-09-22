//
//  FileManager+Default.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/18/23.
//

import Foundation
import Dependencies

extension FileManager {
  static func getDocumentsDirectory() -> URL {
    @Dependency(\.logger) var logger
    guard let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first 
    else {
      logger.critical("Cannot find the documents directory")
      XCTFail("Failed to find the documents directory")
      return URL.currentDirectory()
    }
    
    return documentsDirectory
  }
}

extension UserSettings {
  struct PathError: Error {
    let message: String
    
    init(message: String = "🔴 No Error Message Given") {
      self.message = message
    }
  }
  
  /// Checks if UserSettings.json exists in Documents Directory and returns it
  /// Will attempt to create it if it doesn't exist
  /// - Returns: the URL of UserSettings.json
  static func getUserSettingsFolderURL() throws -> URL {
    @Dependency(\.logger) var logger
    let manager = FileManager.default
    
    let documentsDirectory = FileManager.getDocumentsDirectory()
    let userSettingsPath = documentsDirectory.appending(path: "UserSettings.json")
    guard manager.fileExists(atPath: userSettingsPath.absoluteString)
    else {
      logger.notice("UserSettings.json doesn't exist. Creating now")
      let data = try! JSONEncoder().encode(UserSettings())
      let successful = manager.createFile(atPath: userSettingsPath.absoluteString, contents: data)
      if successful {
        return userSettingsPath
      } else {
        logger.warning("Failed to create UserSettings file. Check if disk is full")
        throw PathError(message: "Failed to create UserSettings file. Check if disk is full")
      }
    }
    return userSettingsPath
  }
  
  struct LocalizableError: LocalizedError {
    var errorDescription: String? = "You fucked up"
    var recoverySuggestion: String? = "fix it"
  }
  
  struct LoadError: Error {
    let message: String
    
    init(message: String = "🔴 No Error Message Given") {
      self.message = message
    }
  }
  
  @Sendable
  static func loadFromFileManager() -> UserSettings {
    @Dependency(\.logger) var logger
    let manager = FileManager.default
    
    guard let userSettingsPath = try? Self.getUserSettingsFolderURL()
    else {
      logger.warning("Failed to load UserSettings from disk. Returning placeholder instead.")
      return UserSettings()
    }
    do {
      if let data = manager.contents(atPath: userSettingsPath.absoluteString) {
        let userSettings = try JSONDecoder().decode(UserSettings.self, from: data)
        return userSettings
        
      } else {
        logger.warning("Failed to read UserSettings object from UserSettings.json URL. Check URL: \(userSettingsPath)")
        return UserSettings()
      }
    } catch {
      logger.critical("Failed to decode UserSettings.json")
      return UserSettings()
    }
  }
  
  struct SaveError: Error {
    let message: String
    
    init(message: String = "🔴 No Error Message Given") {
      self.message = message
    }
  }
  
  @Sendable
  static func saveToFileManager(_ newValue: UserSettings) throws {
    @Dependency(\.dataWriter) var dataWriter
    @Dependency(\.logger) var logger
    guard let userSettingsPath = try? Self.getUserSettingsFolderURL()
    else {
      logger.critical("Failed to save UserSettings")
      throw SaveError(message: "Failed to save UserSettings")
    }
    let data = try JSONEncoder().encode(newValue)
    
    do {
      try dataWriter.write(data, to: userSettingsPath)
    } catch {
      logger.warning("Failed to write UserSettings to disk.")
      throw SaveError(message: "Failed to write UserSettigns to disk.")
    }
    
  }
}
