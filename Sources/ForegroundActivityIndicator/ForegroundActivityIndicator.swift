// The Swift Programming Language
// https://docs.swift.org/swift-book

import NVActivityIndicatorView
import SwiftUI
import UIKit

// MARK: - コンテナビュー

private class IndicatorOverlayContainerView: UIView {}

// MARK: - 純粋関数

private func getKeyWindow() -> UIWindow? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first(where: { $0.isKeyWindow })
    else {
        return nil
    }
    return window
}

private func createNVActivityIndicatorView(
    type: NVActivityIndicatorType,
    color: UIColor
) -> NVActivityIndicatorView {
    let indicator = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 50, height: 50),
        type: type,
        color: color
    )
    indicator.startAnimating()
    return indicator
}

private func createContainerView(
    frame: CGRect,
    indicatorView: UIView,
    labelOffset: CGFloat,
    text: String?,
    textColor: UIColor,
    backgroundColor: UIColor
) -> IndicatorOverlayContainerView {
    let containerView = IndicatorOverlayContainerView(frame: frame)
    containerView.backgroundColor = backgroundColor
    containerView.isUserInteractionEnabled = true
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    indicatorView.center = containerView.center
    indicatorView.autoresizingMask = [
        .flexibleLeftMargin, .flexibleRightMargin,
        .flexibleTopMargin, .flexibleBottomMargin
    ]
    containerView.addSubview(indicatorView)

    if let text {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        label.sizeToFit()
        label.center = CGPoint(x: containerView.center.x, y: containerView.center.y + labelOffset)
        label.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        containerView.addSubview(label)
    }

    return containerView
}

// MARK: - モディファイア

struct UIActivityIndicatorModifier: ViewModifier {
    private let isVisible: Bool
    private let type: NVActivityIndicatorType
    private let text: String?
    private let backgroundColor: UIColor
    private let foregroundColor: UIColor

    init(
        isVisible: Bool,
        type: NVActivityIndicatorType,
        text: String?,
        backgroundColor: UIColor,
        foregroundColor: UIColor
    ) {
        self.isVisible = isVisible
        self.type = type
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: isVisible) {
                if isVisible {
                    showActivityIndicator()
                } else {
                    removeActivityIndicator()
                }
            }
    }

    private func showActivityIndicator() {
        guard let window = getKeyWindow() else { return }

        // 既存のコンテナビューがある場合は削除する
        removeActivityIndicator()

        let indicatorView = createNVActivityIndicatorView(type: type, color: foregroundColor)
        let containerView = createContainerView(
            frame: window.bounds,
            indicatorView: indicatorView,
            labelOffset: 40,
            text: text,
            textColor: foregroundColor,
            backgroundColor: backgroundColor
        )

        window.addSubview(containerView)
    }

    private func removeActivityIndicator() {
        guard let window = getKeyWindow() else { return }

        if let containerView = window.subviews.first(where: { $0 is IndicatorOverlayContainerView }) {
            containerView.removeFromSuperview()
        }
    }
}

// MARK: - ビュー拡張

public extension View {
    /// アクティビティインジケーターをオーバーレイ表示するカスタムモディファイア
    /// - Parameters:
    ///   - isVisible: アクティビティインジケーターの表示フラグ
    ///   - type: インジケーターのタイプ
    ///   - text: インジケーター下に表示するテキスト
    ///   - backgroundColor: 背景色と透明度を指定
    ///   - foregroundColor: インジケーターとテキストの色を指定
    /// - Returns: 修正されたビュー
    func activityIndicator(
        isVisible: Bool,
        type: NVActivityIndicatorType = .lineSpinFadeLoader,
        text: String? = nil,
        backgroundColor: UIColor = UIColor.clear,
        foregroundColor: UIColor = .gray
    ) -> some View {
        modifier(
            UIActivityIndicatorModifier(
                isVisible: isVisible,
                type: type,
                text: text,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
        )
    }
}

// MARK: - プレビュー

#if DEBUG

    #Preview {
        @Previewable @State var isVisible = false

        return TabView {
            NavigationView {
                VStack {
                    Image(systemName: "1.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                .navigationTitle("画面1")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.blue, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .activityIndicator(
                    isVisible: isVisible,
                    type: .ballSpinFadeLoader,
                    text: "ローディング...",
                    backgroundColor: .gray.withAlphaComponent(0.5),
                    foregroundColor: .white
                )
                .onAppear {
                    isVisible = true
                }
            }
            .tag(0)
            .tabItem { Label("One", systemImage: "1.circle") }

            NavigationView {
                VStack {
                    Image(systemName: "2.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
            .tag(1)
            .tabItem { Label("Two", systemImage: "2.circle") }
        }
    }

#endif
