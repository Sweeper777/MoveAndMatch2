import UIKit

enum ProjectBackground : Codable {
    case color(UIColor)
    case image(UIImage)
    
    enum CodingKeys : CodingKey {
        case color
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let color = try container.decodeIfPresent(Color.self, forKey: CodingKeys.color) {
            self = .color(color.uiColor)
        } else if let imageData = try container.decodeIfPresent(Data.self, forKey: .image) {
            guard  let image = UIImage(data: imageData) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.image], debugDescription: "data not in image format"))
            }
            self = .image(image)
        }
        throw DecodingError.keyNotFound(CodingKeys.color, DecodingError.Context(codingPath: [CodingKeys.image, .color], debugDescription: "No color or image keys found"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .color(let color):
            try container.encode(Color(uiColor: color), forKey: .color)
        case .image(let image):
            guard let imageData = image.pngData() ?? image.jpegData(compressionQuality: 1) else {
                throw EncodingError.invalidValue(image, EncodingError.Context(codingPath: [CodingKeys.image], debugDescription: "Image must be either png or jpg"))
            }
            try container.encode(imageData, forKey: .image)
        }
    }
    
}
