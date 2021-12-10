import Foundation

enum FilterButton: CaseIterable, Hashable {
    case star
    case followers
    case date
    case order

    var name: String {
        let languageCode = Locale.preferredLanguages.first ?? "pt-BR"
        return self.localizedName(language: languageCode)!
    }

    private func localizedName(language code: String) -> String? {
        localizations[code]?[self]
    }
}

private let localizations: [String: [FilterButton: String]] = [
    "pt-BR": [
        .star: "Estrelas",
        .followers: "Seguidores",
        .date: "Data",
        .order: "ordem"
    ],

    "en": [
        .star: "Stars",
        .followers: "Followers",
        .date: "Date",
        .order: "order"
    ]
]
