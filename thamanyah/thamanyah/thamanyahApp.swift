//
//  thamanyahApp.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

@main
struct thamanyahApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(homeUseCase: HomeUseCase(repository: HomeRepo())))
        }
    }
}
