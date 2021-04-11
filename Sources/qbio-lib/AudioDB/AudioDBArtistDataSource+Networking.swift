import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension AudioDBArtistDataSource {
    /// Executes a given URL / query synchronously
    func executeQuery(query: URL) throws -> String {
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

    func executeQueryAsync(
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
            throw ServiceError.internalError
        }

        guard let data = data, error == nil else {
            throw error!
        }

        return data
    }

    private func parseDataResultToArtist(data: Data) throws -> Artist {
        let res = try JSONDecoder().decode(ArtistQueryResponse.self, from: data)
        guard let artist = res.artists?.first else {
            throw ServiceError.artistNotFound
        }
        return artist
    }
}

enum ServiceError: Error {
    case internalError
    case artistNotFound
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .internalError:
            return NSLocalizedString(
                "An internal error in the provider occurred. Please try again later.", comment: "")
        case .artistNotFound:
            return NSLocalizedString("The given artist was not found.", comment: "")
        }
    }
}
