import Foundation
import XCTest
@testable import OnyxKodeSecurityLab

final class SecureMessageValidatorTests: XCTestCase {

    func testAuthorizedFreshMessagePasses() throws {
        let now = Date()
        let message = SecureMessage(senderID: "peer-A", payload: Data("hello".utf8), createdAt: now)
        XCTAssertNoThrow(try SecureMessageValidator.validate(message, now: now) { $0 == "peer-A" })
    }

    func testUnauthorizedSenderFails() {
        let now = Date()
        let message = SecureMessage(senderID: "peer-X", payload: Data("hello".utf8), createdAt: now)
        XCTAssertThrowsError(try SecureMessageValidator.validate(message, now: now) { _ in false })
    }

    func testStaleMessageFails() {
        let now = Date()
        let old = now.addingTimeInterval(-300)
        let message = SecureMessage(senderID: "peer-A", payload: Data("hello".utf8), createdAt: old)
        XCTAssertThrowsError(try SecureMessageValidator.validate(message, now: now) { _ in true })
    }
}