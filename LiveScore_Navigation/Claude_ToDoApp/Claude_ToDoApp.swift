//
//  Claude_ToDoApp.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture
import Combine

// MARK: - ToDo 모델
struct ToDo: Equatable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

// MARK: - AppState_Claude
class AppState_Claude: ObservableObject {
    static let shared = AppState_Claude()
    @Published var mainNavi: [Screen_Claude] = []
    @Published var todos: [ToDo] = []
    
    private init() {}
}

// MARK: - Screen_Claude 열거형 수정
enum Screen_Claude: Equatable, Identifiable, Hashable {
    case todoList(TodoListReducer.State)
    case addTodo(AddTodoReducer.State)
    case todoDetail(TodoDetailReducer.State)
    
    var id: UUID {
        switch self {
        case .todoList(let state): return state.id
        case .addTodo(let state): return state.id
        case .todoDetail(let state): return state.id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - MainNaviView
struct MainNaviView_Claude: View {
    @EnvironmentObject var appState: AppState_Claude
    
    var body: some View {
        NavigationStack(path: $appState.mainNavi) {
            TodoListView(
                store: Store(initialState: TodoListReducer.State()) {
                    TodoListReducer()
                }
            )
            .navigationDestination(for: Screen_Claude.self) { screen in
                switch screen {
                case .todoList(let state):
                    TodoListView(
                        store: Store(initialState: state) {
                            TodoListReducer()
                        })
                case .addTodo(let state):
                    AddTodoView(
                        store: Store(initialState: state) {
                            AddTodoReducer()
                        })
                case .todoDetail(let state):
                    TodoDetailView(
                        store: Store(initialState: state) {
                            TodoDetailReducer()
                        })
                }
            }
        }
    }
}

// MARK: - TodoListReducer
@Reducer
struct TodoListReducer {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        var todos: [ToDo] = []
    }
    
    enum Action {
        case onAppear
        case addTodoTapped
        case todoTapped(ToDo)
        case toggleCompleted(ToDo)
        case deleteTodo(IndexSet)
        case updateTodos
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.updateTodos)
            case .addTodoTapped:
                NaviPath_Claude.main.push(.addTodo(AddTodoReducer.State()))
                return .none
            case .todoTapped(let todo):
                NaviPath_Claude.main.push(.todoDetail(.init(todo: todo)))
                return .none
            case .toggleCompleted(let todo):
                if let index = state.todos.firstIndex(where: { $0.id == todo.id }) {
                    state.todos[index].isCompleted.toggle()
                    AppState_Claude.shared.todos = state.todos
                }
                return .none
            case .deleteTodo(let indexSet):
                state.todos.remove(atOffsets: indexSet)
                AppState_Claude.shared.todos = state.todos
                return .none
            case .updateTodos:
                state.todos = AppState_Claude.shared.todos
                return .none
            }
        }
    }
}

// MARK: - TodoListView
struct TodoListView: View {
    @EnvironmentObject var appState: AppState_Claude
    let store: StoreOf<TodoListReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.todos) { todo in
                    HStack {
                        Text(todo.title)
                        Spacer()
                        if todo.isCompleted {
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        viewStore.send(.todoTapped(todo))
                    }
                    .swipeActions {
                        Button {
                            viewStore.send(.toggleCompleted(todo))
                        } label: {
                            Label("Toggle", systemImage: "checkmark.circle")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { indexSet in
                    viewStore.send(.deleteTodo(indexSet))
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewStore.send(.addTodoTapped)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onChange(of: appState.todos) { _ in
                viewStore.send(.updateTodos)
            }
        }
    }
}

// MARK: - AddTodoReducer
@Reducer
struct AddTodoReducer {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        var title: String = ""
        
        init(id: UUID = UUID(), title: String = "") {
            self.id = id
            self.title = title
        }
    }
    
    enum Action {
        case setTitle(String)
        case addTodo
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setTitle(let title):
                state.title = title
                return .none
            case .addTodo:
                let newTodo = ToDo(id: UUID(), title: state.title, isCompleted: false)
                AppState_Claude.shared.todos.append(newTodo)
                NaviPath_Claude.main.pop()
                return .none
            }
        }
    }
}

// MARK: - AddTodoView
struct AddTodoView: View {
    @EnvironmentObject var appState: AppState_Claude
    let store: StoreOf<AddTodoReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                TextField("Todo Title", text: viewStore.binding(
                    get: \.title,
                    send: AddTodoReducer.Action.setTitle
                ))
                Button("Add Todo") {
                    viewStore.send(.addTodo)
                }
            }
            .navigationTitle("Add Todo")
        }
    }
}

// MARK: - TodoDetailReducer
@Reducer
struct TodoDetailReducer {
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        var todo: ToDo
    }
    
    enum Action {
        case toggleCompleted
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleCompleted:
                state.todo.isCompleted.toggle()
                if let index = AppState_Claude.shared.todos.firstIndex(where: { $0.id == state.todo.id }) {
                    AppState_Claude.shared.todos[index] = state.todo
                }
                return .none
            }
        }
    }
}

// MARK: - TodoDetailView
struct TodoDetailView: View {
    @EnvironmentObject var appState: AppState_Claude
    let store: StoreOf<TodoDetailReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Text(viewStore.todo.title)
                Toggle("Completed", isOn: viewStore.binding(
                    get: \.todo.isCompleted,
                    send: TodoDetailReducer.Action.toggleCompleted
                ))
            }
            .navigationTitle("Todo Detail")
        }
    }
}

enum NaviPath_Claude: CaseIterable {
    case main
    
    static func push(_ screen: Screen_Claude) {
        self.main.push(screen)
    }
    static func pop() {
        self.main.pop()
    }
    static func popRoot() {
        self.main.popRoot()
    }
    
    static func popToIndex(_ index: Int) {
        self.main.popToIndex(index)
    }
    
    func push(_ screen: Screen_Claude) {
        switch self {
        case .main:
            AppState_Claude.shared.mainNavi.append(screen)
        }
    }
    
    func pop() {
        switch self {
        case .main:
            if AppState_Claude.shared.mainNavi.count > 0 {
                AppState_Claude.shared.mainNavi.removeLast()
            }
        }
    }
    func popRoot() {
        switch self {
        case .main:
            AppState_Claude.shared.mainNavi = []
        }
    }
    
    func popToIndex(_ index: Int) {
        switch self {
        case .main:
            if AppState_Claude.shared.mainNavi.count > 0 {
                if index > 0 && index < AppState_Claude.shared.mainNavi.count {
                    AppState_Claude.shared.mainNavi.removeLast(index)
                }
                else {
                    AppState_Claude.shared.mainNavi.removeLast()
                }
            }
        }
    }
}

//@main
//struct YourAppName: App {
//    @StateObject private var appState = AppState_Claude.shared
//    
//    var body: some Scene {
//        WindowGroup {
//            MainNaviView_Claude()
//                .environmentObject(appState)
//        }
//    }
//}
