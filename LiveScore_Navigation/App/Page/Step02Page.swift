//
//  Step02Page.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Step02PageReducer {
    
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        var txt = ""
        
        init(viewData: String) {
            txt = viewData
        }
    }
    
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

struct Step02Page: View {
    let store: StoreOf<Step02PageReducer>
    
    var body: some View {
        Text("viewData : \(store.txt)")
    }
}

#Preview {
    Step02Page(
        store: Store(initialState: Step02PageReducer.State(viewData: "")) {
            Step02PageReducer()
        }
    )
}
