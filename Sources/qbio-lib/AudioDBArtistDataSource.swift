import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct AudioDBArtistDataSource: ArtistDataSource {
    private var baseUrl = URLComponents(
        string: "https://www.theaudiodb.com/api/v1/json/1/search.php")!

    func getBio(artist: String) -> String {
        guard let queryUrl = try? createQueryUrl(artist: artist) else {
            return "No bio found"
        }

        return try! executeQuery(query: queryUrl)
    }

    func getBioAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) {
        guard let queryUrl = try? createQueryUrl(artist: artist) else {
            resultHandler(nil, QueryError.invalidQueryString)
            return
        }

        executeQueryAsync(query: queryUrl, resultHandler: resultHandler)
    }

    private func createQueryUrl(artist: String) throws -> URL {
        // create and use a copy to not modify the base url of this struct
        var baseUrlCopy = baseUrl
        let baseUrlItem = URLQueryItem(name: "s", value: artist)
        baseUrlCopy.queryItems = [baseUrlItem]

        if let url = baseUrlCopy.url {
            return url
        } else {
            throw QueryError.invalidQueryString
        }
    }

    private func executeQuery(query: URL) throws -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var result: String?
        var queryError: Error?

        executeQueryAsync(query: query) { bio, error in
            guard let bio = bio else {
                queryError = error
                return
            }

            result = bio
            semaphore.signal()
        }
        semaphore.wait()

        guard
            let bio = result,
            queryError == nil
        else {
            throw queryError!
        }
        return bio
    }

    private func executeQueryAsync(
        query: URL, resultHandler: @escaping (String?, Error?) -> Void
    ) {
        URLSession.shared.dataTask(with: query) { data, response, error in
            do {
                let res = try JSONDecoder().decode(ArtistQueryResponse.self, from: data!)
                resultHandler(res.artists.first!.strBiographyEN, nil)
            } catch {
                resultHandler(nil, QueryError.invalidEndpoint)
            }

        }.resume()
    }
}

enum QueryError: Error {
    case invalidQueryString
    case invalidEndpoint
}

struct Artist: Codable {
    let strBiographyEN: String
}

struct ArtistQueryResponse: Codable {
    let artists: [Artist]
}
