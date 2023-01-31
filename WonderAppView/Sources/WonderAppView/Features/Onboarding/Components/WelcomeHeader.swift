//
//  WelcomeHeader.swift
//  WonderApp
//
//  Created by Valentin Radu on 21/01/2023.
//

import SFSafeSymbols
import SwiftUI

extension GraphicsContext {
    func fill(roundedRect rect: CGRect,
              cornerRadius: CGFloat,
              with: Shading,
              style: FillStyle = FillStyle()) {
        fill(
            Path(roundedRect: rect, cornerRadius: cornerRadius),
            with: with,
            style: style
        )
    }

    func fill(rect: CGRect,
              with: Shading,
              style: FillStyle = FillStyle()) {
        fill(
            Path(CGPath(rect: rect, transform: nil)),
            with: with,
            style: style
        )
    }
}

extension TimeInterval {
    func rotate(upperBound: Self = 1) -> Self {
        if self < 0 {
            return (upperBound + self).rotate(upperBound: upperBound)
        } else {
            return self
        }
    }
}

private final class WelcomeAnimation: ObservableObject {
    enum Element {
        case rock
        case van
        case tree
        case wheel
        case clouds
        case pickMeUp
        case surf
    }

    private let _referenceDate: Date = .now
    private var _vanFreezeTime: Date?
    private let _referenceDuration: TimeInterval

    init(duration: TimeInterval) {
        _referenceDuration = duration
        _vanFreezeTime = nil
    }

    func progress(date: Date, speed: Double) -> Double {
        let relativeDuration = _referenceDuration / speed
        return _referenceDate.distance(to: date).truncatingRemainder(dividingBy: relativeDuration) / relativeDuration
    }

    func update(in context: GraphicsContext,
                date: Date,
                size: CGSize) {
        let width = size.width
        let height = size.height
        let floor = CGRect(x: 0,
                           y: size.height - 3,
                           width: size.width,
                           height: 3)

        guard let rockSymbol = context.resolveSymbol(id: Element.rock),
              let treeSymbol = context.resolveSymbol(id: Element.tree),
              let cloudsSymbol = context.resolveSymbol(id: Element.clouds),
              let vanSymbol = context.resolveSymbol(id: Element.van),
              let wheelSymbol = context.resolveSymbol(id: Element.wheel),
              let pickMeUpSymbol = context.resolveSymbol(id: Element.pickMeUp),
              let surfSymbol = context.resolveSymbol(id: Element.surf)
        else {
            #if DEBUG
                context.draw(Image(systemSymbol: .nosign),
                             at: CGPoint(x: size.width / 2, y: size.height / 2),
                             anchor: .center)
            #endif
            return
        }

        let rockProgress = progress(date: date, speed: 2)
        let treeProgress = progress(date: date, speed: 1)
        let cloudsProgress = progress(date: date, speed: 0.25)
        let vanProgress = progress(date: _vanFreezeTime ?? date, speed: 10)
        let rockX = (width + rockSymbol.size.width) * (0.7 - rockProgress).rotate()
        let treeX = (width + treeSymbol.size.width) * (0.9 - treeProgress).rotate()
        let cloudsX = width * (1 - cloudsProgress)
        let vanX = 0.35 * width
        let vanYVariance = cos(2 * .pi * vanProgress + .pi) * 3
        let surfYVariance = cos(2 * .pi * vanProgress + .pi) * 4
        let vanY = height - floor.height - wheelSymbol.size.height / 2

        context.draw(cloudsSymbol,
                     at: .init(x: cloudsX, y: height - 80),
                     anchor: .bottomTrailing)

        context.draw(cloudsSymbol,
                     at: .init(
                         x: cloudsX + width,
                         y: height - 80
                     ),
                     anchor: .bottomTrailing)

        context.draw(treeSymbol,
                     at: .init(x: treeX, y: height),
                     anchor: .bottomTrailing)

        context.draw(vanSymbol,
                     at: .init(x: vanX, y: vanY + vanYVariance),
                     anchor: .bottomTrailing)

        context.draw(surfSymbol,
                     at: .init(x: vanX - 10, y: vanY + surfYVariance - vanSymbol.size.height),
                     anchor: .bottomTrailing)

        context.draw(wheelSymbol,
                     at: .init(x: vanX - 7, y: vanY + wheelSymbol.size.height / 2),
                     anchor: .bottomTrailing)

        context.draw(wheelSymbol,
                     at: .init(x: vanX - vanSymbol.size.width + 20, y: vanY + wheelSymbol.size.height / 2),
                     anchor: .bottomLeading)

        context.fill(rect: floor,
                     with: .color(.white))

        context.draw(rockSymbol,
                     at: .init(x: rockX, y: height),
                     anchor: .bottomTrailing)

        context.draw(pickMeUpSymbol,
                     at: .init(x: vanX + vanSymbol.size.width, y: height - 100),
                     anchor: .bottomTrailing)
    }

    func freezeVan() {
        _vanFreezeTime = .now
    }

    func unfreezeVan() {
        _vanFreezeTime = nil
    }
}

struct WelcomeHeader: View {
    @StateObject private var _animation = WelcomeAnimation(duration: 6)
    @State private var _vanOffset: CGSize = .zero
    @State private var _isDragging: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas(
                renderer: { context, size in
                    _animation.update(in: context,
                                      date: timeline.date,
                                      size: size)
                },
                symbols: {
                    Image.ds.rock.tag(WelcomeAnimation.Element.rock)
                    _van
                    Image.ds.tree.tag(WelcomeAnimation.Element.tree)
                    Image.ds.clouds.tag(WelcomeAnimation.Element.clouds)
                    _pickMeUp
                }
            )
            .frame(greedy: .both)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(Color.ds.oceanBlue900.edgesIgnoringSafeArea(.all))
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !_isDragging {
                        _animation.freezeVan()
                    }
                    _isDragging = true
                    _vanOffset = value.translation
                }
                .onEnded { value in
                    _isDragging = false
                    _vanOffset.height = 0
                    _animation.unfreezeVan()
                }
        )
        .onChange(of: _vanOffset) { newValue in
            if newValue.height == 0 {
                _vanOffset.width = 0
            }
        }
    }

    @ViewBuilder
    private var _van: some View {
        Group {
            Image.ds.surf
                .tag(WelcomeAnimation.Element.surf)
            Image.ds.wheel
                .tag(WelcomeAnimation.Element.wheel)
            Image.ds.van
                .tag(WelcomeAnimation.Element.van)
        }
        .offset(_vanOffset)
        .animation(
            .easeInOut(duration: _isDragging ? 0.25 : 1).delay(_isDragging ? 0 : 0.25),
            value: _vanOffset.width
        )
        .animation(.easeInOut, value: _vanOffset.height)
    }

    @ViewBuilder
    private var _pickMeUp: some View {
        Image.ds.pickMeUp
            .tag(WelcomeAnimation.Element.pickMeUp)
            .opacity(_vanOffset.height != 0 ? 0 : 1)
            .animation(.easeInOut, value: _vanOffset)
    }
}

struct WelcomeHeaderPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            WelcomeHeader()
            Spacer()
        }
    }
}