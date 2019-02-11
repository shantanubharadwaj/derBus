//
//  der_BusTests.swift
//  der BusTests
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import XCTest
@testable import der_Bus

class der_BusTests: XCTestCase {
    
    private var testData: String!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testData = TestCaseData.defaultData.get()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testData = nil
    }

    func testJSONParsing() {
        do{
            let busInfo: BusInformationResponse = try testData.decode()
            let count = busInfo.infolist.first?.invList.count ?? 0
            XCTAssertTrue(count == 26, "Bus JSON Response properly parsed")
        }catch let error {
            XCTAssertFalse(true, "Details Error : \(error)")
        }
    }
    
    func testJSONParsingWithBusDetailsObject() {
        do{
            let busInfo: BusInformationResponse = try testData.decode()
            let details = BusDetailsList(source: busInfo)
            let count = details?.busDetails.count ?? 0
            XCTAssertTrue(count == 26, "Bus Details properly parsed")
        }catch let error {
            XCTAssertFalse(true, "Details Error : \(error)")
        }
    }
    
    func testBusDetailsObjectElements() {
        do{
            let busInfo: BusInformationResponse = try testData.decode()
            let details = BusDetailsList(source: busInfo)
            if let firstBusInfo = details?.busDetails.first {
                XCTAssertEqual(firstBusInfo.rating, 2.2, "Correct Bus details not extracted. Value mismatch")
                XCTAssertEqual(firstBusInfo.totalRatingCount, 11, "Correct Bus details not extracted. Value mismatch")
            }else{
                XCTAssertFalse(true, "Details from first index not found")
            }
        }catch let error {
            print("Details Error : \(error)")
            XCTAssertFalse(true)
        }
    }

}
