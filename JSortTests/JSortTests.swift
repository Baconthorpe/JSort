//
//  JSortTests.swift
//  JSortTests
//
//  Created by Ezekiel Abuhoff on 9/20/16.
//  Copyright © 2016 Ezekiel Abuhoff. All rights reserved.
//

import XCTest
@testable import JSort

class JSortTests: XCTestCase {
    
    // MARK: Tests
    
    func testJSortBasics() {
        let jsonString = "{\"sky_is_blue\":{\"cheese\":true,\"butter\":null}}"
        let jsonData = jsonString.data(using: String.Encoding.utf8)!
        
        guard let jsortObject = JSort(jsonData) else { XCTFail(); return }
        
        XCTAssert(jsortObject.dictionary != nil)
        XCTAssert(jsortObject["sky_is_blue"].dictionary != nil)
        XCTAssert(jsortObject["sky_is_blue"]["cheese"].bool != nil)
        XCTAssert(jsortObject["sky_is_blue"]["butter"].isNull)
        XCTAssert(jsortObject["sky_is_blue"]["milk"].bool == nil)
        XCTAssert(jsortObject["sky_is_blue"]["milk"].isValid != true)
    }
}
