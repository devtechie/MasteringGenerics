// StackExample.swift

import Foundation
struct Stack<T> {
    private var items = [T]()
    
    mutating func put(item: T) {
        items.insert(item, at: 0)
    }
    
    mutating func pop() -> T? {
        return items.count > 0 ? items.removeFirst() : nil
    }
    
    func peek() -> T? {
        return items.first
    }
}

func stackExample() {
    
    var st = Stack<Int>()
    st.put(item: 1)
    st.put(item: 2)
    st.put(item: 3)
    print(st.peek() ?? "")
    
    var item = st.pop()
    while item != nil {
        print(item ?? "")
        item = st.pop()
    }
    
}
