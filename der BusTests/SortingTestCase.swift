//
//  SortingTestCase.swift
//  der BusTests
//
//  Created by Shantanu Dutta on 09/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import XCTest
@testable import der_Bus

class SortingTestCase: XCTestCase {

    private var busDetailsList: BusDetailsList?
    override func setUp() {
        let testData = TestCaseData.miniData.get()
        let busInfo: BusInformationResponse? = try? testData.decode()
        busDetailsList = (busInfo != nil) ? BusDetailsList(source: busInfo!) : nil
    }
    
    override func tearDown() {
        busDetailsList = nil
    }

    func testSorting_RatingsLowHigh() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .Rating_LowHigh)
            let firstRating = sortedList.first?.rating ?? -1
            XCTAssertEqual(firstRating, 0, "Sorted List not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testSorting_RatingsHighLow() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .Rating_HighLow)
            let firstRating = sortedList.first?.rating ?? -1
            XCTAssertEqual(firstRating, 4.2, "Filtered AC bus count not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testSorting_DepartureTimeLowHigh() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .DepartureTime_LowHigh)
            let departureTime = sortedList.first?.departureTime
            let dateString = "01/12/2017 11:30:00 PM"
            let date = DateFormatter.iso8601Full.date(from: dateString)
            XCTAssertEqual(departureTime, date, "Sorted List not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testSorting_DepartureTimeHighLow() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .DepartureTime_HighLow)
            let departureTime = sortedList.first?.departureTime
            let dateString = "02/12/2017 11:59:00 PM"
            let date = DateFormatter.iso8601Full.date(from: dateString)
            XCTAssertEqual(departureTime, date, "Sorted List not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testSorting_FareLowHigh() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .Fare_LowHigh)
            let lowFare = sortedList.first?.busFare ?? -1
            XCTAssertEqual(lowFare, 30.0, "Sorted List not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
    
    func testSorting_FareHighLow() {
        if let detailsList = busDetailsList?.busDetails {
            let sortedList = SortEngine.sort(busList: detailsList, with: .Fare_HighLow)
            let highFare = sortedList.first?.busFare ?? -1
            XCTAssertEqual(highFare, 60.0, "Sorted List not correct")
        }else{
            XCTAssertFalse(true, "Bus details list not found")
        }
    }
}
