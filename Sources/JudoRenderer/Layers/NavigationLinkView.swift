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

struct NavigationLinkView: SwiftUI.View {
    @Environment(\.data) private var data
    @Environment(\.properties) private var properties
    @Environment(\.fetchedImage) private var fetchedImage
    @EnvironmentObject private var documentState: DocumentData

    @ObservedObject var navigationLink: JudoModel.NavigationLink
    var body: some SwiftUI.View {
        NavigationLink {
            ForEach(navigationLink.destination.children.allOf(type: Layer.self)) {
                LayerView(layer: $0)
            }
            .environment(\.properties, properties)
            .environment(\.data, data)
            .environment(\.fetchedImage, fetchedImage)
            .environmentObject(documentState)
        } label: {
            ForEach(navigationLink.label.children.allOf(type: Layer.self)) {
                LayerView(layer: $0)
            }
        }
    }
}
