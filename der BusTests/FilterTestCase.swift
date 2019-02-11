//
//  FilterTestCase.swift
//  der BusTests
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import XCTest
@testable import der_Bus

class FilterTestCase: XCTestCase {

    private var busDetailsList: BusDetailsList?
    override func setUp() {
        let testData = TestCaseData.miniData.get()
        let busInfo: BusInformationResponse? = try? testData.decode()
        busDetailsList = (busInfo != nil) ? BusDetailsList(source: busInfo!) : nil
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        busDetailsList = nil
    }

    func testFilterWithBusType_AC() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: .AC)
            XCTAssertEqual(filteredList.count, 6, "Filtered AC bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_NonAC() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: .NONAC)
            XCTAssertEqual(filteredList.count, 1, "Filtered Non AC bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_Sleeper() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: .SLEEPER)
            XCTAssertEqual(filteredList.count, 1, "Filtered Sleeper bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: .SEATER)
            XCTAssertEqual(filteredList.count, 6, "Filtered Seater bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_NonAC() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .NONAC])
            XCTAssertEqual(filteredList.count, 7, "Filtered AC bus & Non Ac bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_Sleeper() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .SLEEPER])
            XCTAssertEqual(filteredList.count, 6, "Filtered AC bus & Sleepr bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .SEATER])
            XCTAssertEqual(filteredList.count, 7, "Filtered AC bus & Seater bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_NonAC_Sleeper() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.NONAC, .SLEEPER])
            XCTAssertEqual(filteredList.count, 2, "Filtered NonAC bus & Sleeper bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_NonAC_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.NONAC, .SEATER])
            XCTAssertEqual(filteredList.count, 6, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_Sleeper_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.SEATER, .SLEEPER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_NonAc_Sleeper() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .NONAC, .SLEEPER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_NonAc_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .NONAC, .SEATER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_AC_Sleeper_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .SLEEPER, .SEATER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_NonAc_Sleeper_Seater() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.NONAC, .SLEEPER, .SEATER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testFilterWithBusType_All() {
        if let detailsList = busDetailsList?.busDetails {
            let filteredList = FilterEngine.filter(busList: detailsList, for: [.AC, .NONAC ,.SLEEPER, .SEATER])
            XCTAssertEqual(filteredList.count, 7, "Filtered Buses count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
}
