//
//  File.swift
//
//
//  Created by Valentin Radu on 16/02/2023.
//

import SwiftUI

extension Onboarding {
    struct ViewModel {
        let model: Model

        func onAppear(fragment: Fragment) {}

        var askEmailOutlet: Outlet<Void> {
            .inactive()
        }

        var askPasswordOutlet: Outlet<AskPasswordControlName> {
            .inactive()
        }

        var locateMeOutlet: Outlet<LocateAccountControlName> {
            .inactive()
        }

        var welcomeOutlet: Outlet<Void> {
            Outlet {
                model.advance(towards: .askEmail)
            }
        }
    }
}
