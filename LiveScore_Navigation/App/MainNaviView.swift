//
//  MainNaviView.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture

struct MainNaviView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        NavigationStack(path: $appState.mainNavi) {
            Step01Page(
                store: Store(initialState: Step01PageReducer.State()) {
                    Step01PageReducer()
                }
            )
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .step01(let state):
                    Step01Page(
                        store: Store(initialState: state, reducer: {
                            Step01PageReducer()
                        }))
                case .step02(let state):
                    Step02Page(
                        store: Store(initialState: state, reducer: {
                            Step02PageReducer()
                        }))
                case .step03(let state):
                    Step03Page(
                        store: Store(initialState: state, reducer: {
                            Step03PageReducer()
                        }))
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    MainNaviView()
}
