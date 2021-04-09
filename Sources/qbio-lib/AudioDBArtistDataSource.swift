import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct AudioDBArtistDataSource: ArtistDataSource {
    private var baseUrl = URLComponents(
        string: "https://www.theaudiodb.com/api/v1/json/1/search.php")!

    public init() {}

    public func getBio(artist: String) -> String {
        guard let queryUrl = try? createQueryUrl(artist: artist) else {
            return "No bio found"
        }

        return try! executeQuery(query: queryUrl)
    }

    public func getBioAsync(artist: String, resultHandler: @escaping (String?, Error?) -> Void) {
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
            guard let bio = bio, error == nil else {
                queryError = error
                semaphore.signal()
                return
            }

            result = bio
            semaphore.signal()
        }
        semaphore.wait()

        guard let bio = result, queryError == nil else {
            throw queryError!
        }
        return bio
    }

    private func executeQueryAsync(
        query: URL, resultHandler: @escaping (String?, Error?) -> Void
    ) {
        let session = URLSession.shared
        session.dataTask(with: query) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                resultHandler(nil, QueryError.serviceError)
                return
            }

            guard let data = data, error == nil else {
                resultHandler(nil, error)
                return
            }

            do {
                let res = try JSONDecoder().decode(ArtistQueryResponse.self, from: data)
                resultHandler(res.artists.first!.strBiographyEN, nil)
                return
            } catch {
                resultHandler(nil, QueryError.serviceError)
            }

        }.resume()
    }
}

enum QueryError: Error {
    case invalidQueryString
    case serviceError
}

// TODO: Implement in console app?
extension QueryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidQueryString:
            return NSLocalizedString("An invalid query value was passed. Please try another one.", comment: "")
        case .serviceError:
            return NSLocalizedString("An error in an external service occured. Please try later.", comment: "")
        }
    }
}

struct Artist: Codable {
    let strBiographyEN: String
}

struct ArtistQueryResponse: Codable {
    let artists: [Artist]
}
