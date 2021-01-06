import UIKit

class ViewController: UIViewController {
    
    var people = [Person]()
    
    private lazy var tableView: GenericTableView<Person, PersonCell> = {
        let v = GenericTableView<Person, PersonCell>(items: people) { (person, cell) in
            cell.person = person
        } selectionHandler: { (person) in
            print(person.name, person.gender)
        }
        
        return v
    }()
    
//    private lazy var tableView: RegularTableView = {
//        let v = RegularTableView(items: people.map { $0.name }) { (name, cell) in
//            cell.textLabel?.text = name
//        } selectionHandler: { (selectedName) in
//            print(selectedName)
//        }
//
//        return v
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //stackExample()
//        NetworkManager().fetch(url: URL(string: "https://swapi.dev/api/people/?search=sky")!) { (results) in
//            switch results {
//            case .failure(let error):
//                print(error)
//            case .success(let data):
//                let json = try? JSONDecoder().decode(SWAPIEnvelope.self, from: data)
//                print(json ?? "---- NO DATA----")
//            }
//        }
        
        getPeople()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
    }
    
    func getPeople() {
        GenericNetworkManager<SWAPIEnvelope>().fetch(url: URL(string: "https://swapi.dev/api/people/?search=sky")!) { (results) in
            switch results {
            case .failure(let err):
                print(err)
            case .success(let swapi):
                print(swapi ?? "-- NO DATA--")
                if let people = swapi?.results {
                    self.people = people
                    self.tableView.reload(data: self.people)
                }
                self.getFilm(for: swapi?.results[0])
            }
        }
    }
    
    func getFilm(for person: Person?) {
        guard let person = person else {
            return
        }
        
        GenericNetworkManager<Film>().fetch(url: URL(string: person.films[0])!) { (results) in
            switch results {
            case .failure(let err):
                print(err)
            case .success(let film):
                print(film ?? "--- NO Data--")
            }
        }
    }

    func theBasics() {
        let someValue = 10
        print(someValue)
        
        
    }
    
    func add(a: Int, b: Int) -> Int {
        return a + b
    }

    func add(a: Double, b: Double) -> Double {
        return a + b
    }
    
    func genericAdd<T: Numeric>(a: T, b: T) -> T {
        return a + b
    }
    
    func useAdd() {
        
        let _ = genericAdd(a: 10, b: 10)
        let _ = genericAdd(a: 3.14, b: 1.25)
        
        
        /*
         
         func genericAdd(a: Int, b: Int) -> Int {
             return a + b
         }
         
         func genericAdd(a: Double, b: Double) -> Double {
             return a + b
         }
         
         
         */
    }
    
    func linearSearch<T: Equatable>(array: [T], key: T) -> Int? {
        for i in 0..<array.count {
            if array[i] == key {
                return i
            }
        }
        return nil
    }
    
    func useLinearSearch() {
        let cars = ["Honda", "Toyota", "Ford", "Tesla"]
        if let carIdx = linearSearch(array: cars, key: "Ford") {
            print(carIdx)
        }
        
        let items = [1, 2, 3, 5, 7, 4, 10]
        if let itemIdx = linearSearch(array: items, key: 10) {
            print(itemIdx)
        }
    }
    
    struct Person1: Equatable {
        let name: String
        let age: Int
        
        static func == (lhs: Person1, rhs: Person1) -> Bool {
            if lhs.name == rhs.name && lhs.age == rhs.age {
                return true
            }
            
            return false
        }
    }
    
    func usePersonExample() {
        let jim = Person1(name: "Jim", age: 23)
        let jim2 = Person1(name: "Jim", age: 23)
        
        let bob = Person1(name: "Bob", age: 40)
        
        print(jim == jim2)
        print(jim == bob)
        
        let people = [jim, jim2, bob]
        if let bobIdx = linearSearch(array: people, key: bob) {
            print(people[bobIdx].age)
        }
    }

}

protocol Drivable {
    func speed()
}

class Car: Drivable {
    func speed() {
        print("Top speed 160 mph")
    }
}

class Truck: Drivable {
    func speed() {
        print("Top speed 120 mph")
    }
}

class Tractor: Drivable {
    func speed() {
        print("Top speed 40 mph")
    }
}

protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Addable {}

extension Double: Addable {}

func customAdd<T: Addable>(a: T, b: T) -> T {
    return a + b
}

func customAddExample() {
    let addInt = customAdd(a: 4, b: 5)
    print(addInt)
    
    let addDouble = customAdd(a: 3.14, b: 1.24)
    print(addDouble)
}


struct Book {
    var title = ""
    var author = ""
}
//
//protocol Storage {
//    func store(item: Book)
//    func retrieve(index: Int) -> Book
//}
//
//class Bookcase: Storage {
//
//    private var books = [Book]()
//
//    func store(item: Book) {
//        books.append(item)
//    }
//
//    func retrieve(index: Int) -> Book {
//        return books[index]
//    }
//}
//
//struct VideoGame {
//    var title = ""
//    var publisher = ""
//}
//
//class VideoCase: Storage {
//    private var games = [VideoGame]()
//
//    func store(item: VideoGame) {
//        games.append(item)
//    }
//
//    func retrieve(index: Int) -> VideoGame {
//        return games[index]
//    }
//}

protocol Storage {
    associatedtype Item
    func store(item: Item)
    func retrieve(index: Int) -> Item
}

class Box<Item>: Storage {
    var items = [Item]()
    
    func store(item: Item) {
        items.append(item)
    }
    
    func retrieve(index: Int) -> Item {
        return items[index]
    }
}

func useStorage() {
    let booksBox = Box<Book>()
    booksBox.store(item: Book(title: "Swift Development", author: "DevTechie"))
    booksBox.store(item: Book(title: "iOS Development", author: "DevTechie"))
    
    print(booksBox.retrieve(index: 0).author)
    
    struct Game {
        var title = ""
        var publisher = ""
    }
    
    let gamesBox = Box<Game>()
    gamesBox.store(item: Game(title: "Swift Ninja", publisher: "DevTechie"))
    gamesBox.store(item: Game(title: "iOS Ninja", publisher: "DevTechie"))
    
    print(gamesBox.retrieve(index: 0).publisher)
}

class GiftBox<Item>: Box<Item> {
    func wrap() {
        print("Gift wrap the box")
    }
}

func useSubclass() {
    struct Toy {
        var name: String
    }
    
    let toyBox = GiftBox<Toy>()
    toyBox.store(item: Toy(name: "Sheriff Woody"))
    toyBox.store(item: Toy(name: "Buzz Lightyear"))
    toyBox.wrap()
}


enum Location {
    case address(String)
    case coordinate(Double, Double)
}

func useLocation() {
    let loc1 = Location.address("123 main st")
    let loc2 = Location.coordinate(40.23211, -122.23244)
    print(loc1, loc2)
}


enum GenLocation<T> {
    case address(T)
    case coordinate(T)
}

func useGenericLocation() {
    struct Address {
        var streetNumber: Int
        var streetName: String
        var city: String
        var zipCode: Int
    }
    
    let loc1 = GenLocation.address(Address(streetNumber: 123, streetName: "main st", city: "New York", zipCode: 11002))
    print(loc1)
    
    struct Coordinate {
        let lat: Double
        let long: Double
    }
    
    let loc2 = GenLocation.coordinate(Coordinate(lat: 40.23211, long: -122.23244))
    print(loc2)
}
