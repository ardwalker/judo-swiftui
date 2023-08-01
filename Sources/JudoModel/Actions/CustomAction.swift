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

import Foundation

public final class CustomAction: Action {
    @Published public var identifier: TextValue
    @Published @objc public dynamic var parameters: [Parameter]
    
    init(identifier: TextValue, parameters: [Parameter] = []) {
        self.identifier = identifier
        self.parameters = parameters
        super.init()
    }
    
    public required init() {
        self.identifier = "Custom"
        self.parameters = []
        super.init()
    }
    
    // MARK: NSCopying
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let action = super.copy(with: zone) as! CustomAction
        action.identifier = identifier
        action.parameters = parameters
        return action
    }
    
    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case identifier
        case parameters
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(TextValue.self, forKey: .identifier)
        parameters = try container.decode([Parameter].self, forKey: .parameters)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(parameters, forKey: .parameters)
        try super.encode(to: encoder)
    }
}