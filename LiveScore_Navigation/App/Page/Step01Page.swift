//
//  Step01Page.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Step01PageReducer {
    
    @ObservableState
    struct State: Equatable {
        var id = UUID()
    }
    
    enum Action {
        case goStep02Page
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .goStep02Page:
                NaviPath.main.push(.step02(.init(viewData: "Step02 View Data Test :)")))
                return .none
            }
        }
    }
}

struct Step01Page: View {
    let store: StoreOf<Step01PageReducer>
    
    var body: some View {
        Button(action: {
        }, label: {
            Text("Step02Page 로 이동하기")
        })
    }
}

#Preview {
    Step01Page(
        store: Store(initialState: Step01PageReducer.State()) {
            Step01PageReducer()
        }
    )
}
