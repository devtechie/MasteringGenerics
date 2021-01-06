// RegularTableView.swift

import UIKit

final class RegularTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private var items: [String]
    private var config: (String, UITableViewCell) -> Void
    private var selectionHandler: (String) -> Void
    
    private let reuseID = "CELL"
    
    init(items: [String], config: @escaping (String, UITableViewCell) -> Void, selectionHandler: @escaping (String) -> Void) {
        self.items = items
        self.config = config
        self.selectionHandler = selectionHandler
        
        super.init(frame: .zero, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        config(items[indexPath.row], cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler(items[indexPath.row])
    }
}

extension RegularTableView {
    func reload(data items: [String]) {
        self.items = items
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
