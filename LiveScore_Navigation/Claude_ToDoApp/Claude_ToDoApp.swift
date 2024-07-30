//
//  Claude_ToDoApp.swift
//  LiveScore_Navigation
//
//  Created by kimhongpil on 7/28/24.
//

import SwiftUI
import ComposableArchitecture

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
        var addTodoState: AddTodoReducer.State?
        var todoDetailState: TodoDetailReducer.State?
        
        
        // Api
        var allToDoList: [TodosData]?
        var isLoading = false
        var error: ApiError?
        
    }
    
    enum Action {
        case onAppear
        case addTodoTapped
        case todoTapped(ToDo)
        case toggleCompleted(ToDo)
        case deleteTodo(IndexSet)
        case addTodo(AddTodoReducer.Action)
        case todoDetail(TodoDetailReducer.Action)
        
        // Api
        case getAllTodoList
        case getAllTodoListResponse(TaskResult<[TodosData]>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                fLog("idpil::: called TodoList onAppear :>")
                
                return .none
            case .addTodoTapped:
                state.addTodoState = AddTodoReducer.State()
                return .run { send in
                    await NaviPath_Claude.main.push(.addTodo(AddTodoReducer.State()))
                }
            case .todoTapped(let todo):
                state.todoDetailState = TodoDetailReducer.State(todo: todo)
                return .run { send in
                    await NaviPath_Claude.main.push(.todoDetail(.init(todo: todo)))
                }
            case .toggleCompleted(let todo):
                if let index = state.todos.firstIndex(where: { $0.id == todo.id }) {
                    state.todos[index].isCompleted.toggle()
                }
                return .none
            case .deleteTodo(let indexSet):
                state.todos.remove(atOffsets: indexSet)
                return .none
            case .addTodo(.delegate(.didAddTodo(let newTodo))):
                print("idpil::: called addTodo")
                state.todos.append(newTodo)
                return .run { _ in
                    await NaviPath_Claude.main.pop()
                }
            case .addTodo:
                return .none
            case .todoDetail(.toggleCompleted):
                if var todo = state.todoDetailState?.todo,
                   let index = state.todos.firstIndex(where: { $0.id == todo.id }) {
                    todo.isCompleted.toggle()
                    state.todos[index] = todo
                    state.todoDetailState?.todo = todo
                }
                return .none
                
                
                // Api
            case .getAllTodoList:
                state.isLoading = true
                state.error = nil
                
                return .run { send in
                    await send(.getAllTodoListResponse(
                        TaskResult { try await apiClient.getTodoAllList()}
                    ))
                }
                
            case let .getAllTodoListResponse(.success(data)):
                state.isLoading = false
                state.allToDoList = data
                return .none
                
            case let .getAllTodoListResponse(.failure(error)):
                state.isLoading = false
                state.error = error as? ApiError ?? .unknownError(error.localizedDescription)
                return .none
            }
        }
        .ifLet(\.addTodoState, action: /Action.addTodo) {
            AddTodoReducer()
        }
        .ifLet(\.todoDetailState, action: /Action.todoDetail) {
            TodoDetailReducer()
        }
    }
}

// MARK: - TodoListView
struct TodoListView: View {
    let store: StoreOf<TodoListReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
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
                
                if (viewStore.allToDoList?.count ?? 0) > 0 {
                    if let todoList = viewStore.allToDoList {
                        List {
                            ForEach(todoList, id: \.self) { todo in
                                HStack {
                                    Text(todo.title ?? "")
                                    Spacer()
                                }
                            }
                        }
                    }
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
                
                // api
                viewStore.send(.getAllTodoList)
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
    }
    
    enum Action {
        case setTitle(String)
        case addTodoButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didAddTodo(ToDo)
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setTitle(let title):
                state.title = title
                return .none
            case .addTodoButtonTapped:
                print("idpil::: called addTodoButtonTapped")
                let newTodo = ToDo(id: UUID(), title: state.title, isCompleted: false)
                print("idpil::: newTodo : \(newTodo)")
                return .send(.delegate(.didAddTodo(newTodo)))
            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - AddTodoView
struct AddTodoView: View {
    let store: StoreOf<AddTodoReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                TextField("Todo Title", text: viewStore.binding(
                    get: \.title,
                    send: AddTodoReducer.Action.setTitle
                ))
                Button("Add Todo") {
                    viewStore.send(.addTodoButtonTapped)
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
                return .none
            }
        }
    }
}

// MARK: - TodoDetailView
struct TodoDetailView: View {
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
        Task { @MainActor in
            self.main.push(screen)
        }
    }
    
    static func pop() {
        Task { @MainActor in
            self.main.pop()
        }
    }
    
    static func popRoot() {
        Task { @MainActor in
            self.main.popRoot()
        }
    }
    
    static func popToIndex(_ index: Int) {
        Task { @MainActor in
            self.main.popToIndex(index)
        }
    }
    
    func push(_ screen: Screen_Claude) {
        Task { @MainActor in
            switch self {
            case .main:
                AppState_Claude.shared.mainNavi.append(screen)
            }
        }
    }
    
    func pop() {
        Task { @MainActor in
            switch self {
            case .main:
                if AppState_Claude.shared.mainNavi.count > 0 {
                    AppState_Claude.shared.mainNavi.removeLast()
                }
            }
        }
    }
    
    func popRoot() {
        Task { @MainActor in
            switch self {
            case .main:
                AppState_Claude.shared.mainNavi = []
            }
        }
    }
    
    func popToIndex(_ index: Int) {
        Task { @MainActor in
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
