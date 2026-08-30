import Foundation

public let rssiWindowSize = 5
public let rssiStaleInterval: TimeInterval = 3

public struct RssiWindow: Equatable {
    public private(set) var samples: [Int]
    private let limit: Int

    public init(limit: Int = rssiWindowSize) {
        samples = []
        self.limit = limit
    }

    public mutating func push(_ rssi: Int) {
        samples.append(rssi)
        if samples.count > limit { samples.removeFirst() }
    }

    public mutating func reset() {
        samples = []
    }

    public var average: Int? {
        if samples.isEmpty { return nil }
        return samples.reduce(0, +) / samples.count
    }
}
