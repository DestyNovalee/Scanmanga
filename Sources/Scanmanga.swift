
import Foundation
import PaperbackExtensions
import SwiftSoup

public final class Scanmanga: Source {
    public let id: Int = 1234567890 // Change cet ID par un nombre unique
    public let name: String = "Scanmanga"
    public let baseUrl: String = "https://scanmanga.com"
    public let lang: Language = .french
    public let supportsLatest: Bool = true

    public init() {}

    public func getMangas(request: Request, page: Int) async throws -> MangasPage {
        let url = "\(baseUrl)/mangas?page=\(page)"
        let data = try await request.data(url: url)
        let html = String(data: data, encoding: .utf8) ?? ""

        let mangas = try parseMangas(html: html)
        let hasNextPage = !mangas.isEmpty

        return MangasPage(mangas: mangas, hasNextPage: hasNextPage)
    }

    private func parseMangas(html: String) throws -> [Manga] {
        let doc: Document = try SwiftSoup.parse(html)
        let mangaElements: Elements = try doc.select("div.manga-item")

        var mangas: [Manga] = []

        for element in mangaElements.array() {
            let title = try element.select("h3.title").text()
            let id = try element.select("a").attr("href").replacingOccurrences(of: "/manga/", with: "")
            let cover = try element.select("img.cover").attr("src")

            mangas.append(Manga(id: id, title: title, imageUrl: cover))
        }
        return mangas
    }

    public func getChapters(request: Request, mangaId: String) async throws -> [Chapter] {
        let url = "\(baseUrl)/manga/\(mangaId)"
        let data = try await request.data(url: url)
        let html = String(data: data, encoding: .utf8) ?? ""

        return try parseChapters(html: html)
    }

    private func parseChapters(html: String) throws -> [Chapter] {
        let doc: Document = try SwiftSoup.parse(html)
        let chapterElements = try doc.select("ul.chapter-list li a")

        var chapters: [Chapter] = []

        for element in chapterElements.array() {
            let title = try element.text()
            let id = try element.attr("href").replacingOccurrences(of: "/manga/chapter/", with: "")
            let date = Date()

            chapters.append(Chapter(id: id, title: title, dateUpdated: date))
        }
        return chapters
    }

    public func getPages(request: Request, mangaId: String, chapterId: String) async throws -> [Page] {
        let url = "\(baseUrl)/manga/\(mangaId)/chapter/\(chapterId)"
        let data = try await request.data(url: url)
        let html = String(data: data, encoding: .utf8) ?? ""

        return try parsePages(html: html)
    }

    private func parsePages(html: String) throws -> [Page] {
        let doc: Document = try SwiftSoup.parse(html)
        let imageElements = try doc.select("div.page-content img")

        var pages: [Page] = []

        for (index, element) in imageElements.array().enumerated() {
            let url = try element.attr("src")
            pages.append(Page(url: url, index: index))
        }
        return pages
    }

    public func search(request: Request, query: String, page: Int) async throws -> MangasPage {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(baseUrl)/search?query=\(encodedQuery)&page=\(page)"
        let data = try await request.data(url: url)
        let html = String(data: data, encoding: .utf8) ?? ""

        let mangas = try parseMangas(html: html)
        let hasNextPage = !mangas.isEmpty

        return MangasPage(mangas: mangas, hasNextPage: hasNextPage)
    }

    public func getLatestUpdates(request: Request, page: Int) async throws -> MangasPage {
        let url = "\(baseUrl)/latest?page=\(page)"
        let data = try await request.data(url: url)
        let html = String(data: data, encoding: .utf8) ?? ""

        let mangas = try parseMangas(html: html)
        let hasNextPage = !mangas.isEmpty

        return MangasPage(mangas: mangas, hasNextPage: hasNextPage)
    }
}
