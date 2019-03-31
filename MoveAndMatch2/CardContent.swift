import UIKit

enum CardContents : Codable {
    case text(NSAttributedString)
    case image(UIImage)
    
    enum CodingKeys : CodingKey {
        case text
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let textData = try container.decodeIfPresent(Data.self, forKey: CodingKeys.text) {
            let text = try NSAttributedString(data: textData, options: [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            self = .text(text)
        } else if let imageData = try container.decodeIfPresent(Data.self, forKey: .image) {
           guard  let image = UIImage(data: imageData) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.image], debugDescription: "data not in image format"))
            }
            self = .image(image)
        }
        throw DecodingError.keyNotFound(CodingKeys.text, DecodingError.Context(codingPath: [CodingKeys.image, .text], debugDescription: "No text or image keys found"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            let textData = try text.data(from: NSRange(location: 0, length: text.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
            try container.encode(textData, forKey: .text)
        case .image(let image):
            guard let imageData = image.pngData() ?? image.jpegData(compressionQuality: 1) else {
                throw EncodingError.invalidValue(image, EncodingError.Context(codingPath: [CodingKeys.image], debugDescription: "Image must be either png or jpg"))
            }
            try container.encode(imageData, forKey: .image)
        }
    }
    
}
