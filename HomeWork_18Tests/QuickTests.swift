import Foundation
import Quick
import Nimble
import RealmSwift
import OHHTTPStubs
@testable import HomeWork_18

class Quicktests: QuickSpec {
    override func spec() {
        describe("ArrayChanger") {
            let changer = ArrayChanger(data: [1,6,9,4,5,8,6,5,4])
            it("its sort") {
                expect(changer.sorter().data).to(equal([1,4,4,5,5,6,6,8,9]))
            }
            it("Its contain") {
                expect(changer.contain(7)).to(beNil())
                expect(changer.contain(5)).to(equal(5))
            }
            it("Its max and min") {
                expect(changer.max()).to(equal(9))
                expect(changer.min()).to(equal(1))
            }
            it("Its sum") {
                expect(changer.sum()).to(equal(48))
            }
        }
    }
}

class RealmTests : QuickSpec {
    override class func tearDown() {
        
    }
    override func spec() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
        describe("RealmTests") {
            var testHumanRealm = HumanRealm()
            
            beforeEach {
                testHumanRealm = HumanRealm()
            }
            
            afterEach {
                try! testHumanRealm.realm.write {
                    testHumanRealm.realm.deleteAll()
                }
            }
            
            it("Add") {
                let count = testHumanRealm.get().count
                testHumanRealm.add(human: HumanGenerator.shared.generate())
                let newCount = testHumanRealm.get().count
                expect(newCount).to(equal(count + 1))
            }
            it("Delete") {
                let randomHuman = HumanGenerator.shared.generate()
                testHumanRealm.add(human: randomHuman)
                expect(testHumanRealm.get().contains(randomHuman)).to(equal(true))
                testHumanRealm.delete(human: randomHuman)
                expect(testHumanRealm.get().contains(randomHuman)).to(equal(false))
            }
            it("Oldest") {
                let old = Human().set(name: "Old", date: Date(timeIntervalSince1970: 0), height: 167.0, sex: .male)
                let young = Human().set(name: "Young", date: Date(timeIntervalSince1970: 123234345), height: 180.0, sex: .female)
                testHumanRealm.add(human: old)
                testHumanRealm.add(human: young)
                expect(testHumanRealm.oldest()).to(equal(old))
                expect(testHumanRealm.youngest()).to(equal(young))
            }
        }
    }
}

class JSONTests: QuickSpec {
    override func spec() {
        let downloader = WeatherData(api: "test.io")
        stub(condition: isPath(downloader.api)) { _ in
            guard let path = OHPathForFile("JSON.json", type(of: self)) else {
                preconditionFailure("OHPathForFile error")
            }
            return HTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }
        
        let e = expectation(description: "Weather")
        downloader.getData()
        describe("Weather") {
            it("parses") {
                expect(downloader.weatherData?.count).to(equal(8))
                expect(downloader.weatherData?["18:00"]?.temp).to(equal(20))
            }
        }
        e.fulfill()
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
