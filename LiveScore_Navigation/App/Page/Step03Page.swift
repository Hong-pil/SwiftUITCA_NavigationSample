//
//  Step03Page.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Step03PageReducer {
    
    @ObservableState
    struct State: Equatable {
        var id = UUID()
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

struct Step03Page: View {
    let store: StoreOf<Step03PageReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Step03Page(
        store: Store(initialState: Step03PageReducer.State()) {
            Step03PageReducer()
        }
    )
}
