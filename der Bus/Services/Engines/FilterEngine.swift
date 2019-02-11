//
//  FIlterEngine.swift
//  der Bus
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

enum FilterOptions {
    case AC
    case NONAC
    case SLEEPER
    case SEATER
    case NONE
    
    func get() -> FilterEngine.FilterAttributes {
        switch self {
        case .AC:
            return FilterEngine.FilterAttributes.AC
        case .NONAC:
            return FilterEngine.FilterAttributes.NONAC
        case .SLEEPER:
            return FilterEngine.FilterAttributes.SLEEPER
        case .SEATER:
            return FilterEngine.FilterAttributes.SEATER
        case .NONE:
            return FilterEngine.FilterAttributes.NONE
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .AC:
            return "AC"
        case .NONAC:
            return "NON AC"
        case .SLEEPER:
            return "SLEEPER"
        case .SEATER:
            return "SEATER"
        default:
            return ""
        }
    }
}

struct FilterEngine {
    static func availableFilterOptions() -> [FilterOptions] {
        return [FilterOptions.AC, FilterOptions.NONAC, FilterOptions.SLEEPER, FilterOptions.SEATER]
    }
    
    internal struct FilterAttributes: OptionSet, Hashable, CustomStringConvertible {
        let rawValue: UInt
        
        static let NONE     = FilterAttributes(rawValue: 1 << 0)
        static let AC       = FilterAttributes(rawValue: 1 << 1)
        static let NONAC    = FilterAttributes(rawValue: 1 << 2)
        static let SLEEPER  = FilterAttributes(rawValue: 1 << 3)
        static let SEATER   = FilterAttributes(rawValue: 1 << 4)
        static let ALL: FilterAttributes = [FilterAttributes.AC, .NONAC, .SEATER, .SLEEPER]
        
        private static var optionSelected = ""
        var description: String {
            FilterAttributes.optionSelected = "["
            if contains(.AC) {
                FilterAttributes.optionSelected += " {AC} "
            }
            if contains(.NONAC) {
                FilterAttributes.optionSelected += " {NONAC} "
            }
            if contains(.SLEEPER) {
                FilterAttributes.optionSelected += " {SLEEPER} "
            }
            if contains(.SEATER) {
                FilterAttributes.optionSelected += " {SEATER} "
            }
            FilterAttributes.optionSelected += "]"
            return FilterAttributes.optionSelected
        }
    }
    
    static func filter(busList list: [BusInfoDetails], for options: FilterAttributes) -> [BusInfoDetails] {
        
        return filterList(list: list, options: options)
    }
    
    fileprivate static func filterList(list: [BusInfoDetails], options: FilterAttributes) -> [BusInfoDetails] {
        switch options {
        case .AC:
            return list.filter{ $0.busType.IsAc }
        case .NONAC:
            return list.filter{ $0.busType.IsNonAc }
        case .SLEEPER:
            return list.filter{ $0.busType.IsSleeper }
        case .SEATER:
            return list.filter{ $0.busType.IsSeater }
        case [.AC, .NONAC]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsNonAc
            }
        case [.AC, .SLEEPER]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsSleeper
            }
        case [.AC, .SEATER]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsSeater
            }
        case [.NONAC, .SLEEPER]:
            return list.filter{
                $0.busType.IsSleeper ||
                $0.busType.IsNonAc
            }
        case [.NONAC, .SEATER]:
            return list.filter{
                $0.busType.IsSeater ||
                $0.busType.IsNonAc
            }
        case [.SLEEPER, .SEATER]:
            return list.filter{
                $0.busType.IsSleeper ||
                $0.busType.IsSeater
            }
        case [.AC, .NONAC, .SLEEPER]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsNonAc ||
                $0.busType.IsSleeper
            }
        case [.AC, .NONAC, .SEATER]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsNonAc ||
                $0.busType.IsSeater
            }
        case [.AC, .SLEEPER, .SEATER]:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsSleeper ||
                $0.busType.IsSeater
            }
        case [.NONAC, .SLEEPER, .SEATER]:
            return list.filter{
                $0.busType.IsNonAc ||
                $0.busType.IsSleeper ||
                $0.busType.IsSeater
            }
        case [.AC , .NONAC, .SLEEPER, .SEATER]:fallthrough
        case .ALL:
            return list.filter{
                $0.busType.IsAc ||
                $0.busType.IsNonAc ||
                $0.busType.IsSleeper ||
                $0.busType.IsSeater
            }
            
        case .NONE: fallthrough
        default:
            break
        }
        return [BusInfoDetails] ()
    }
}
