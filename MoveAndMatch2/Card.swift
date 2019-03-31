import UIKit
import SwiftyUtils

class Card : Codable {
    var frame: CGRect = .zero
    var content: CardContents = .text(NSAttributedString())
    var backgroundColor = UIColor.yellow
    
    enum CodingKeys : CodingKey {
        case x, y, width, height
        case content
        case backgroundColor
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .x)
        let y = try container.decode(CGFloat.self, forKey: .y)
        let width = try container.decode(CGFloat.self, forKey: .width)
        let height = try container.decode(CGFloat.self, forKey: .height)
        frame = CGRect(x: x, y: y, width: width, height: height)
        content = try container.decode(CardContents.self, forKey: .content)
        let color = try container.decode(Color.self, forKey: .backgroundColor)
        backgroundColor = color.uiColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frame.x, forKey: .x)
        try container.encode(frame.y, forKey: .y)
        try container.encode(frame.width, forKey: .width)
        try container.encode(frame.height, forKey: .height)
        try container.encode(content, forKey: .content)
        try container.encode(Color(uiColor: backgroundColor), forKey: .backgroundColor)
    }
}

struct Color : Codable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
