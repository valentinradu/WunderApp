//
//  WelcomeHeader.swift
//  VanSurf
//
//  Created by Valentin Radu on 21/01/2023.
//

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
    }

    private let _referenceDate: Date = .now
    private let _referenceDuration: TimeInterval

    init(duration: TimeInterval) {
        _referenceDuration = duration
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
              let pickMeUp = context.resolveSymbol(id: Element.pickMeUp)
        else {
            #if DEBUG
                context.draw(Image(systemName: "nosign"),
                             at: CGPoint(x: size.width / 2, y: size.height / 2),
                             anchor: .center)
            #endif
            return
        }

        let rockProgress = progress(date: date, speed: 2)
        let treeProgress = progress(date: date, speed: 1)
        let cloudsProgress = progress(date: date, speed: 0.25)
        let vanProgress = progress(date: date, speed: 10)
        let rockX = (width + rockSymbol.size.width) * (0.7 - rockProgress).rotate()
        let treeX = (width + treeSymbol.size.width) * (0.9 - treeProgress).rotate()
        let cloudsX = (width + cloudsSymbol.size.width) * (0.9 - cloudsProgress).rotate()
        let vanX = 0.35 * width
        let vanYVariance = cos(2 * .pi * vanProgress + .pi) * 2
        let vanY = height - floor.height - wheelSymbol.size.height / 2

        context.draw(cloudsSymbol,
                     at: .init(x: cloudsX, y: height - 80),
                     anchor: .bottomTrailing)

        context.draw(cloudsSymbol,
                     at: .init(x: cloudsX - cloudsSymbol.size.width - 80, y: height - 120),
                     anchor: .bottomTrailing)

        context.draw(treeSymbol,
                     at: .init(x: treeX, y: height),
                     anchor: .bottomTrailing)

        context.draw(vanSymbol,
                     at: .init(x: vanX, y: vanY + vanYVariance),
                     anchor: .bottomTrailing)

        context.draw(wheelSymbol,
                     at: .init(x: vanX - 7, y: vanY + wheelSymbol.size.height / 2),
                     anchor: .bottomTrailing)

        context.draw(wheelSymbol,
                     at: .init(x: vanX - vanSymbol.size.width + 20, y: vanY + wheelSymbol.size.height / 2),
                     anchor: .bottomLeading)

        context.fill(roundedRect: floor,
                     cornerRadius: floor.height / 2,
                     with: .color(.white))

        context.draw(rockSymbol,
                     at: .init(x: rockX, y: height),
                     anchor: .bottomTrailing)

        context.draw(pickMeUp,
                     at: .init(x: vanX + vanSymbol.size.width, y: height - 100),
                     anchor: .bottomTrailing)
    }
}

struct WelcomeHeader: View {
    @StateObject private var _animation = WelcomeAnimation(duration: 10)
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
                    Image("rock").tag(WelcomeAnimation.Element.rock)
                    _van
                    Image("tree").tag(WelcomeAnimation.Element.tree)
                    Image("clouds").tag(WelcomeAnimation.Element.clouds)
                    _pickMeUp
                }
            )
        }
        .padding(20)
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        .background(Color("BlueBg"))
        .gesture(
            DragGesture()
                .onChanged { value in
                    _isDragging = true
                    _vanOffset = value.translation
                }
                .onEnded { value in
                    _isDragging = false
                    _vanOffset.height = 0
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
            Image("wheel")
                .tag(WelcomeAnimation.Element.wheel)
            Image("van")
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
        Image("pick.me.up")
            .tag(WelcomeAnimation.Element.pickMeUp)
            .opacity(_vanOffset.height != 0 ? 0 : 1)
            .animation(.easeInOut, value: _vanOffset)
    }
}

struct WelcomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WelcomeHeader()
            Spacer()
        }
    }
}
