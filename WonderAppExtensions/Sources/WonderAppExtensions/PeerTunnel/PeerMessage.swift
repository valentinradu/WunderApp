//
//  File.swift
//
//
//  Created by Valentin Radu on 05/03/2023.
//

import Foundation
import Network
import os

enum PeerMessageKind: UInt32 {
    case invalid
    case custom
}

private struct PeerMessageHeader {
    let type: PeerMessageKind
    let length: UInt32

    init(type: PeerMessageKind, length: UInt32) {
        self.type = type
        self.length = length
    }

    init(_ buffer: UnsafeMutableRawBufferPointer) {
        var tempType: UInt32 = 0
        var tempLength: UInt32 = 0
        withUnsafeMutableBytes(of: &tempType) { typePtr in
            typePtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: 0),
                                                            count: MemoryLayout<UInt32>.size))
        }
        withUnsafeMutableBytes(of: &tempLength) { lengthPtr in
            lengthPtr
                .copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!
                        .advanced(by: MemoryLayout<UInt32>.size),
                    count: MemoryLayout<UInt32>.size))
        }
        type = PeerMessageKind(rawValue: tempType) ?? .invalid
        length = tempLength
    }

    var encodedData: Data {
        var tempType = type.rawValue
        var tempLength = length
        var data = Data(bytes: &tempType, count: MemoryLayout<UInt32>.size)
        data.append(Data(bytes: &tempLength, count: MemoryLayout<UInt32>.size))
        return data
    }

    static var encodedSize: Int {
        MemoryLayout<UInt32>.size * 2
    }
}

class PeerMessageDefinition: NWProtocolFramerImplementation {
    static let definition = NWProtocolFramer.Definition(implementation: PeerMessageDefinition.self)
    private let _logger: Logger = .init(subsystem: "com.peertunnel", category: "peer-message-framer")

    static var label: String = "PeerMessageFramer"

    required init(framer: NWProtocolFramer.Instance) {}

    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        .ready
    }

    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        while true {
            var tempHeader: PeerMessageHeader?
            let headerSize = PeerMessageHeader.encodedSize
            let parsed = framer.parseInput(minimumIncompleteLength: headerSize,
                                           maximumLength: headerSize) { buffer, isComplete -> Int in
                guard let buffer = buffer else {
                    return 0
                }
                if buffer.count < headerSize {
                    return 0
                }
                tempHeader = PeerMessageHeader(buffer)
                return headerSize
            }

            guard parsed, let header = tempHeader else {
                return headerSize
            }

            let message = NWProtocolFramer.Message(peerMessageKind: header.type)

            if !framer.deliverInputNoCopy(length: Int(header.length),
                                          message: message,
                                          isComplete: true) {
                return 0
            }
        }
    }

    func handleOutput(
        framer: NWProtocolFramer.Instance,
        message: NWProtocolFramer.Message,
        messageLength: Int,
        isComplete: Bool
    ) {
        let type = message.peerMessageKind
        let header = PeerMessageHeader(type: type, length: UInt32(messageLength))

        framer.writeOutput(data: header.encodedData)

        do {
            try framer.writeOutputNoCopy(length: messageLength)
        } catch {
            _logger.error("\(error)")
        }
    }

    func wakeup(framer: NWProtocolFramer.Instance) {}

    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        true
    }

    func cleanup(framer: NWProtocolFramer.Instance) {}
}

extension NWProtocolFramer.Message {
    convenience init(peerMessageKind: PeerMessageKind) {
        self.init(definition: PeerMessageDefinition.definition)
        self["PeerMessageKind"] = peerMessageKind
    }

    var peerMessageKind: PeerMessageKind {
        if let type = self["PeerMessageKind"] as? PeerMessageKind {
            return type
        } else {
            return .invalid
        }
    }
}
