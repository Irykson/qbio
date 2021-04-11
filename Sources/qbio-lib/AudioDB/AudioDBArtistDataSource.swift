import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct AudioDBArtistDataSource {
    private var baseUrl = URLComponents(
        string: "https://www.theaudiodb.com/api/v1/json/1/search.php")!

    public init() {}

    /// Creates a URL with search parameter with the given `artist`
    internal func createQueryUrl(artist: String) throws -> URL {
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

    /// Executes a given URL / query synchronously
    internal func executeQuery(query: URL) throws -> String {
        // Use a semaphore make this function behave synchronous
        let semaphore = DispatchSemaphore(value: 0)

        // Needs to be declared outside the closure, since you cannot return outside the enclosing function
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

    internal func executeQueryAsync(
        query: URL, resultHandler: @escaping (String?, Error?) -> Void
    ) {
        URLSession.shared.dataTask(with: query) { data, response, error in
            do {
                let data = try validateHTTPResponse(data: data, response: response, error: error)
                let artist = try parseDataResultToArtist(data: data)
                resultHandler(artist.strBiographyEN, nil)
            } catch {
                resultHandler(nil, error)
            }
        }.resume()
    }

    private func validateHTTPResponse(data: Data?, response: URLResponse?, error: Error?) throws
        -> Data
    {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw QueryError.serviceError
        }

        guard let data = data, error == nil else {
            throw error!
        }

        return data
    }

    private func parseDataResultToArtist(data: Data) throws -> Artist {
        let res = try JSONDecoder().decode(ArtistQueryResponse.self, from: data)
        guard let artist = res.artists?.first else {
            throw QueryError.artistNotFound
        }
        return artist
    }
}

enum QueryError: Error {
    case invalidQueryString
    case serviceError
    case artistNotFound
    case noEmptyArtist
}

extension QueryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidQueryString:
            return NSLocalizedString(
                "An invalid query value was passed. Please try another one.", comment: "")
        case .serviceError:
            return NSLocalizedString(
                "An error in an external service occurred. Please try later.", comment: "")
        case .artistNotFound:
            return NSLocalizedString("The given artist was not found.", comment: "")
        case .noEmptyArtist:
            return NSLocalizedString("No artist was passed. Empty String was passed.", comment: "")
        }
    }
}
