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

struct StepperView: SwiftUI.View {
    @Environment(\.componentBindings) private var componentBindings
    @Environment(\.data) private var data

    var stepper: JudoDocument.StepperLayer

    var body: some SwiftUI.View {
        RealizeText(stepper.label) { label in
            switch (range, stepper.step?.forceResolve(propertyValues: componentBindings.propertyValues, data: data)) {
            case (.some(let range), .some(let step)):
                SwiftUI.Stepper(label, value: valueBinding, in: range, step: step)
            case (.some(let range), .none):
                SwiftUI.Stepper(label, value: valueBinding, in: range)
            case (.none, .some(let step)):
                SwiftUI.Stepper(label, value: valueBinding, step: step)
            default:
                SwiftUI.Stepper(label, value: valueBinding)
            }
        }
    }

    private var valueBinding: Binding<Double> {
        Binding {
            stepper.value.forceResolve(
                propertyValues: componentBindings.propertyValues,
                data: data
            )
        } set: { newValue in
            if case .property(let name) = stepper.value.binding {
                componentBindings[name]?.wrappedValue = newValue
            }
        }
    }

    private var range: ClosedRange<Double>? {
        guard let minValue = stepper.minValue?.forceResolve(propertyValues: componentBindings.propertyValues, data: data), let maxValue = stepper.maxValue?.forceResolve(propertyValues: componentBindings.propertyValues, data: data) else { return nil }
        if minValue < maxValue {
            return minValue...maxValue
        } else {
            return nil
        }
    }

}
