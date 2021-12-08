import Foundation

protocol DataMockable: Decodable {
    static var dataMock: Data { get }
}

/*
 * Não e bonito, mas funciona.
 *
 * DataMockable precisa ser implementado para [RepositoryBranchResponseDto] (aka
 * RepositoryBranchesResponseDto) e [RepositoryResponseDto] (aka
 * [RepositoryResponseDto]). Problema é que, para implementar protocolos, a
 * Swift não diferencia entre Array<E1> e Array<E2> sem um hack.
 *
 * Parte desse hack envolve definir uma implmentação padrão de DataMockable e
 * uma padrão para Arrays quando seus elementos implementam Decodable.
 *
 * Quem souber uma forma melhor de fazer isso, favor avise.
 */

extension Array: DataMockable where Element: Decodable { }

extension DataMockable {
    static var dataMock: Data {
        Data()
    }
}
