import Foundation

//MARK: - первоначальная неудобная модель
struct Welcome: Codable {
    let feed: Feed1
}

struct Feed1: Codable {
    let id: Int
    let name: String
    let company: Company1
}

struct Company1: Codable {
    let name: String
    let shortName: String
}


//MARK: - новая удобная модель
struct Feed: Codable {
    let id: Int
    let name: String
    let companyName: String
}


extension Feed {
    enum ModelKeys: String, CodingKey {
        case feed
    }
    
    enum FeedKeys: String, CodingKey {
        case id
        case name
        case company
    }
    
    enum CompanyKeys: String, CodingKey {
        case name
        case shortName
    }
    
    init(from decoder: Decoder) throws {
        //нужно проверить как декодировать если первый верхний элемент в виде массива с одним элементом
        //MARK: - из верхнего во вложенный уровень.
        let values = try decoder.container(keyedBy: ModelKeys.self)
        let feed = try values.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        
        self.id = try feed.decode(Int.self, forKey: .id)
        self.name = try feed.decode(String.self, forKey: .name)
        
        //MARK: -  из вложенного на верхний уровень
        let company = try feed.nestedContainer(keyedBy: CompanyKeys.self, forKey: .company)
        let companyName = try company.decode(String.self, forKey: .name)
        let shortCompanyName = try company.decode(String.self, forKey: .shortName)
        
        self.companyName = companyName + " " + shortCompanyName
    }
}





