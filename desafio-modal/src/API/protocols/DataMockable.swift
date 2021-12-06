import Foundation

protocol DataMockable: Decodable {
    static var dataMock: Data { get }
}
