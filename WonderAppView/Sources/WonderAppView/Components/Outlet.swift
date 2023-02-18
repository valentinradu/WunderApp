//
//  File.swift
//
//
//  Created by Valentin Radu on 17/02/2023.
//

import Foundation

struct Outlet<ControlName> {
    typealias Resolver = (ControlName) -> Void

    static func inactive() -> Outlet where ControlName: Hashable {
        .init(resolver: { _ in })
    }

    static func inactive() -> Outlet where ControlName == Void {
        .init(resolver: {})
    }

    private let _resolver: Resolver
    private let _debounce: Bool

    init(debounce: Bool = false, resolver: @escaping Resolver) where ControlName: Hashable {
        _resolver = resolver
        _debounce = debounce
    }

    init(debounce: Bool = false, resolver: @escaping () -> Void) where ControlName == Void {
        _resolver = { _ in
            resolver()
        }
        _debounce = debounce
    }

    func fire(from name: ControlName) where ControlName: Hashable {
        _resolver(name)
    }

    func fire() where ControlName == Void {
        _resolver(())
    }
}
