import Foundation

public class LinkIdMMP {
    static public func event() {
        HttpRequest(with: "https://jsonplaceholder.typicode.com/todos/1", objectType: ToDo.self) { (result: HttpResult) in
            switch result {
            case .success(let object):
                print(object)
            case .failure(let error):
                print(error)
            }
        }
    }
}
