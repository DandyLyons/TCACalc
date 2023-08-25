//
//  CalculationReducer.swift
//  TCACalc
//
//  Created by Daniel Lyons on 8/22/23.
//

import Foundation
import ComposableArchitecture

extension CalculationReducer.State: CustomDebugStringConvertible {
  var debugDescription: String {
    "CustomDebugStringConvertible not yet implemented"
  }
}

struct CalculationReducer: Reducer {
  enum Operation: String, Equatable {
    case plus, minus, multiply, divide
    
    /// The Order of Operations according to PEMDAS
    enum OrderStep: Int {
      
      /// anything in parentheses
      case P = 1,
           E,
           /// Multiplication and Division
           MD,
           /// Addition and Subtraction
           AS }
    var orderStep: OrderStep {
      switch self {
        case .plus, .minus: return .AS
        case .multiply, .divide: return .MD
      }
    }
  }
  
  struct State: Equatable {
    
    init() {
      self._status = .initial
      self.num1 = 0
      self.op1 = nil
      self.num2 = 0
      self.op2 = nil
      self.num3 = 0
      self.isDecimalOn = false
      self.display = .num1
      self.decimalFormatStyle = .number
    }
    
    /// This should never be called except from one of the `transitionTo` functions
    private var _status: Status
    var status: Status {
      get { self._status }
      set { self.transition(to: newValue) }
    }
    enum Status: String, Equatable {
      case initial
      case t_from_initial
      case transition
      case t_from_transition
      case trailing
      case t_from_trailing
      case equal
    }
    
    var num1: Decimal = 0
    var op1: Operation? = nil
    var num2: Decimal = 0
    var op2: Operation? = nil
    var num3: Decimal = 0
    var isDecimalOn = false
    
    var op_resolved: Operation? {
//      switch status, op1, op2 {
////        case (_ , .none, .none):
////          return nil
//        case (.)
//      }
      switch status {
        case .initial: return nil
        case .t_from_initial: return nil
        case .transition: return self.op1
        case .t_from_transition: return nil
        case .trailing: return self.op2
        case .t_from_trailing: return nil
        case .equal: return nil
      }
    }
    
    var display: Display
    enum Display: Equatable { case num1, num2, num3, error }
    var displayString: String {
      var result: String
      func appendDecimalIfNecessary() {
        // check if decimal should be appended
        var shouldAppend: Bool = false
        let numToDisplay: Decimal = switch self.display {
        case .num1: self.num1
        case .num2: self.num2
        case .num3: self.num3
        case .error: Decimal(0)
        }
        
        if self.isDecimalOn && !numToDisplay.formatted().contains(".") {
          shouldAppend = true
        }
        
        if shouldAppend {
          result.append(".")
        }
      }
      
      switch self.display {
        case .num1:
          result = num1.formatted(decimalFormatStyle)
        case .num2:
          result = num2.formatted(decimalFormatStyle)
        case .num3:
          result = num3.formatted(decimalFormatStyle)
        case .error:
          result = "Error"
      }
      appendDecimalIfNecessary()
      return result
    }
    
    var decimalFormatStyle: Decimal.FormatStyle
    
  }
  enum Action: Equatable {
    case input(Input)
    enum Input: Equatable {
      case int(Int)
      case decimal
      case equals
      case reset
      case operation(Operation)
    }
    
    case delegate(DelegateAction)
    enum DelegateAction: Equatable { case didFinishCalculating }
    
    
  }
  
  // MARK: Dependencies
  // @Dependency(\.routineClient) var routineClient
  
  
  typealias CalcEffect = Effect<CalculationReducer.Action>
  
 
  
  var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        case .delegate: return .none
        case .input:
          switch state.status {
              
            case .initial:
              state.process_initial(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .t_from_initial:
              state.process_t_from_initial(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .transition:
              state.process_transition(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .t_from_transition:
              state.process_t_from_transition(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .trailing:
              state.process_trailing(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .t_from_trailing:
              state.process_t_from_trailing(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
            case .equal:
              state.process_equal(action: action)
              return .run { await $0(.delegate(.didFinishCalculating))}
          }
          
      }
    }
  }
}

extension CalculationReducer.State {
  typealias Action = CalculationReducer.Action
  
  
  mutating private func transition(to newStatus: Self.Status) {
    self._status = newStatus
    switch newStatus {
      case .initial:
        self.num1 = 0
        self.op1 = nil
        self.num2 = 0
        self.op2 = nil
        self.num3 = 0
        self.display = .num1
        self.isDecimalOn = false
      case .t_from_initial:
        self.display = .num1
      case .transition:
        self.display = .num1
      case .t_from_transition:
        self.display = .num2
      case .trailing:
        self.display = .num2
      case .t_from_trailing:
        self.display = .num3
      case .equal:
        self.display = .num1
    }
  }
  
  /// Note: This function does not have any side effects, and cannot.
  mutating func evaluate(_ aNumber: Decimal, _ operation: CalculationReducer.Operation, _ anotherNumber: Decimal) -> Decimal {
    switch operation {
      case .plus:
        aNumber + anotherNumber
      case .minus:
        aNumber - anotherNumber
      case .multiply:
        aNumber * anotherNumber
      case .divide:
        aNumber / anotherNumber
    }
  }
  
  mutating func process_initial(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case .int(let int):
            self.status = .t_from_initial
            self.num1 = Decimal(int)
            
          case .decimal:
            self.num1 = 0
            self.isDecimalOn = true
            self.status = .t_from_initial
          case .equals:
            self.status = .equal
          case .operation(let op):
            self.status = .transition
            self.op1 = op
          case .reset:
            self.status = .initial
        }
    }
  }
  
  
  
  mutating func process_t_from_initial(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case .int(let int):
            self.status = .t_from_initial
            self.num1.append(int)
          case .decimal:
            self.isDecimalOn = true
            self.status = .t_from_initial
          case .equals:
            self.status = .equal
            self.num1 = self.evaluate(num1, op1!, num2)
          case .operation(let op):
            self.op1 = op
            self.num2 = num1
            self.status = .transition
          case .reset:
            if self.num1 != 0 {
              self.num1 = 0
              self.status = .t_from_initial
            } else if self.num1 == 0 {
              self.status = .initial
            }
        }
    }
  }
  
  mutating func process_transition(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case.reset:
            self.status = .t_from_initial
            self.num1 = 0
          case .int(let int):
            self.num2 = Decimal(int)
            self.status = .t_from_transition
          case .decimal:
            self.isDecimalOn = true
            self.display = .num2
            self.status = .t_from_transition
          case .equals:
            self.num1 = self.evaluate(num1, op1!, num2)
            self.status = .equal
          case .operation(let op):
            self.status = .transition
            self.op1 = op
        }
    }
  }
  
  
  
  mutating func process_t_from_transition(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case.reset:
            if self.num2 != 0 {
              self.status = .t_from_transition
            } else {
              self.status = .initial
            }
          case .int(let int):
            self.status = .t_from_transition
            self.num2.append(int)
          case .decimal:
            self.status = .t_from_transition
            self.isDecimalOn = true
          case .equals:
            self.status = .equal
            self.num1 = self.evaluate(num1, self.op1!, num2)
          case .operation(let op):
            switch op.orderStep {
              case .P, .E:
                XCTFail("Unimplemented")
              case .AS:
                self.num1 = self.evaluate(num1, op, num2)
                self.num2 = num1
                self.op1 = op
                self.status = .transition
              case .MD:
                if self.op1?.orderStep == .MD {
                  self.num1 = self.evaluate(num1, op, num2)
                  self.num2 = num1
                  self.op1 = op
                  self.status = .transition
                } else if self.op1?.orderStep == .AS {
                  self.op2 = op
                  self.num3 = self.num2
                  self.status = .trailing
                }
            }
        }
    }
  }
  
  
  
  mutating func process_trailing(action: Action)  {
    // NOTE in this state op1 should always be .AS and op2 should always be .MD
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case.reset:
            self.status = .t_from_trailing
            self.num3 = 0
            self.display = .num3
          case .int(let int):
            self.status = .t_from_trailing
            self.num3 = Decimal(int)
            self.display = .num3
          case .decimal:
            self.status = .t_from_trailing
            self.display = .num3
          case .equals:
            self.num2 = self.evaluate(num2, op2!, num3)
            self.status = .equal
            self.num1 = self.evaluate(num1, op1!, num2)
            
          case .operation(let op):
            if op.orderStep == .MD {
              self.status = .trailing
              self.op2 = op
            } else if op.orderStep == .AS {
              self.num1 = self.evaluate(num2, op2!, num3)
              self.num1 = self.evaluate(num1, op1!, num2)
              self.num2 = self.num1
              self.status = .equal
              self.display = .num1
            }
        }
    }
  }
  
  mutating func process_t_from_trailing(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case.reset:
            if self.num3 == 0 {
              self.status = .initial
            } else if self.num3 != 0 {
              self.num3 = 0
              self.status = .t_from_trailing
            }
          case .int(let int):
            self.num3.append(int)
          case .decimal:
            break
          case .equals:
            self.num2 = self.evaluate(num2, op2!, num3)
            self.status = .equal
            self.num1 = self.evaluate(num1, op1!, num2)
          case .operation(let op):
            if op.orderStep == .MD {
              self.status = .trailing
              self.num2 = self.evaluate(num2, op2!, num3)
              self.num3 = self.num2
              self.op2 = op
              self.display = .num2
            } else if op.orderStep == .AS {
              self.status = .transition
              
              //
              self.num1 = self.evaluate(num2, op2!, num3)
              self.num1 = self.evaluate(num1, op1!, num2)
              self.num2 = self.num1
              self.display = .num1
            }
        }
    }
  }
  
  mutating func process_equal(action: Action)  {
    switch action {
      case .delegate: return
      case .input(let input):
        switch input {
          case.reset:
            self.status = .t_from_initial
            self.num1 = 0
          case .int(let int):
            self.status = .t_from_initial
            self.num1 = Decimal(int)
          case .decimal:
            self.status = .t_from_initial
          case .equals:
            self.num1 = self.evaluate(num1, op1!, num2)
            
          case .operation(let op):
            self.status = .transition
            self.num2 = self.num1
            self.op1 = op
        }
    }
  }
}
