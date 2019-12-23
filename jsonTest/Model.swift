import Foundation

//MARK: - первоначальная неудобная модель
struct Welcome1: Codable {
    let feed: [Feed1]
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
        //MARK: - top lvl container [Feed]
        let container = try decoder.container(keyedBy: ModelKeys.self)
        //MARK: - пробираемся к первому элементу массива. feed[0]
        var feedContainer = try container.nestedUnkeyedContainer(forKey: .feed)
        //MARK: - переводим из topLvl в Feed. Из верхнего уровня в нижний
        let firstFeed = try feedContainer.nestedContainer(keyedBy: FeedKeys.self)
        self.id = try firstFeed.decode(Int.self, forKey: .id)
        self.name = try firstFeed.decode(String.self, forKey: .name)
        
        //MARK: -  из вложенного на верхний уровень
        let company = try firstFeed.nestedContainer(keyedBy: CompanyKeys.self, forKey: .company)
        let companyName = try company.decode(String.self, forKey: .name)
        let shortCompanyName = try company.decode(String.self, forKey: .shortName)
        
        self.companyName = companyName + " " + shortCompanyName
    }
}
//a good answer with description and also a cool thread at all. Saved it.
//https://stackoverflow.com/a/44549825/10106098
//nestedContainer(keyedBy:forKey:) to get a nested object from an object for a given key
//nestedUnkeyedContainer(forKey:) to get a nested array from an object for a given key
//nestedContainer(keyedBy:) to get the next nested object from an array
//nestedUnkeyedContainer() to get the next nested array from an array




