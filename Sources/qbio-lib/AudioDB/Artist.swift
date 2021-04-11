struct Artist: Codable {
    let strBiographyEN: String
}

struct ArtistQueryResponse: Codable {
    let artists: [Artist]?
}