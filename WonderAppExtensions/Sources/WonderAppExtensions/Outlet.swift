//
//  File.swift
//
//
//  Created by Valentin Radu on 17/02/2023.
//

import Foundation

public struct Outlet<ControlName> {
    public typealias Resolver = (ControlName) -> Void

    public static func inactive() -> Outlet where ControlName: Hashable {
        .init(resolver: { _ in })
    }

    public static func inactive() -> Outlet where ControlName == Void {
        .init(resolver: {})
    }

    private let _resolver: Resolver
    private let _debounce: Bool

    public init(debounce: Bool = false, resolver: @escaping Resolver) where ControlName: Hashable {
        _resolver = resolver
        _debounce = debounce
    }

    public init(debounce: Bool = false, resolver: @escaping () -> Void) where ControlName == Void {
        _resolver = { _ in
            resolver()
        }
        _debounce = debounce
    }

    public func fire(from name: ControlName) where ControlName: Hashable {
        _resolver(name)
    }

    public func fire() where ControlName == Void {
        _resolver(())
    }
}
