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

import JudoDocument
import SwiftUI

struct ToggleView: SwiftUI.View {
    @Environment(\.componentBindings) private var componentBindings
    @Environment(\.data) private var data

    var toggle: JudoDocument.ToggleLayer

    var body: some SwiftUI.View {
        RealizeText(toggle.label) { label in
            SwiftUI.Toggle(label, isOn: isOnBinding)
        }
    }

    private var isOnBinding: Binding<Bool> {
        Binding {
            toggle.isOn.forceResolve(
                propertyValues: componentBindings.propertyValues,
                data: data
            )
        } set: { newValue in
            if case .property(let name) = toggle.isOn.binding {
                componentBindings[name]?.wrappedValue = newValue
            }
        }

    }
}
