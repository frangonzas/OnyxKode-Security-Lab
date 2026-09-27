import Foundation

public struct SecureMessage: Equatable, Sendable {
    public let senderID: String
    public let payload: Data
    public let createdAt: Date

    public init(senderID: String, payload: Data, createdAt: Date) {
        self.senderID = senderID
        self.payload = payload
        self.createdAt = createdAt
    }
}

public enum SecureMessageValidator {

    public enum ValidationError: Error, Equatable {
        case missingSender
        case emptyPayload
        case payloadTooLarge
        case staleMessage
        case senderNotAuthorized
    }

    /// Valida estructura, tamaño, frescura y autorización antes de aceptar datos externos.
    public static func validate(
        _ message: SecureMessage,
        now: Date = Date(),
        maximumPayloadBytes: Int = 64 * 1024,
        freshnessWindow: TimeInterval = 120,
        isAuthorized: (String) -> Bool
    ) throws {
        guard !message.senderID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.missingSender
        }
        guard !message.payload.isEmpty else {
            throw ValidationError.emptyPayload
        }
        guard message.payload.count <= maximumPayloadBytes else {
            throw ValidationError.payloadTooLarge
        }
        guard abs(now.timeIntervalSince(message.createdAt)) <= freshnessWindow else {
            throw ValidationError.staleMessage
        }
        guard isAuthorized(message.senderID) else {
            throw ValidationError.senderNotAuthorized
        }
    }
}