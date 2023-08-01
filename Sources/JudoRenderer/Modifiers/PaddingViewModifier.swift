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

import JudoModel
import SwiftUI

struct PaddingViewModifier: SwiftUI.ViewModifier {
    @Environment(\.data) private var data
    @EnvironmentObject private var componentState: ComponentState
    
    @ObservedObject var modifier: JudoModel.PaddingModifier
    
    func body(content: Content) -> some View {
        if let edges {
            content.padding(edges, length)
        } else if let insets {
            content.padding(insets)
        } else {
            content
        }
    }
    
    private var edges: SwiftUI.Edge.Set? {
        guard let edges = modifier.edges else {
            return nil
        }
        
        var result = SwiftUI.Edge.Set()
        
        for edge in edges {
            switch edge {
            case .leading:
                result.insert(.leading)
            case .trailing:
                result.insert(.trailing)
            case .top:
                result.insert(.top)
            case .bottom:
                result.insert(.bottom)
            }
        }
        
        return result
    }
    
    private var length: CGFloat? {
        modifier.length?.resolve(data: data, componentState: componentState).map {
            CGFloat($0)
        }
    }
    
    private var insets: EdgeInsets? {
        guard let leading = modifier.leadingInset,
              let trailing = modifier.trailingInset,
              let top = modifier.topInset,
              let bottom = modifier.bottomInset else {
            return nil
        }
        
        return EdgeInsets(
            top: top.resolve(data: data, componentState: componentState) ?? 0,
            leading: leading.resolve(data: data, componentState: componentState) ?? 0,
            bottom: bottom.resolve(data: data, componentState: componentState) ?? 0,
            trailing: trailing.resolve(data: data, componentState: componentState) ?? 0
        )
    }
}

