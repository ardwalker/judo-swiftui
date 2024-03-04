// Copyright (c) 2023-present, Rover Labs, Inc. All rights reserved.
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Rover.
//
// This copyright notice shall be included in all copies or substantial portions of
// the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI

public struct LineLimitModifier: Modifier {
    public var id: UUID
    public var name: String?
    public var children: [Node]
    public var min: Variable<Double>?
    public var max: Variable<Double>?

    public init(id: UUID, name: String?, children: [Node], min: Variable<Double>?, max: Variable<Double>?) {
        self.id = id
        self.name = name
        self.children = children
        self.min = min
        self.max = max
    }
    
    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case typeName = "__typeName"
        case id
        case name
        case children
        case min
        case max

        // ..<16
        case numberOfLines
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        children = try container.decodeNodes(forKey: .children)
        
        let meta = decoder.userInfo[.meta] as! Meta
        switch meta.version {
        case ..<16:
            if let intValue = try container.decode(Int?.self, forKey: .numberOfLines) {
                max = Variable(LegacyNumberValue(intValue))
            }
        case ..<17:
            if let value = try container.decode(LegacyNumberValue?.self, forKey: .min) {
                min = Variable(value)
            }

            if let value = try container.decode(LegacyNumberValue?.self, forKey: .max) {
                max = Variable(value)
            }
        default:
            min = try container.decode(Variable<Double>?.self, forKey: .min)
            max = try container.decode(Variable<Double>?.self, forKey: .max)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(typeName, forKey: .typeName)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeNodes(children, forKey: .children)
        try container.encode(min, forKey: .min)
        try container.encode(max, forKey: .max)
    }
}
