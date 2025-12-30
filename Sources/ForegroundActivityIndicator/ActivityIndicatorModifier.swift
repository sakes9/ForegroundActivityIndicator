import NVActivityIndicatorView
import SwiftUI
import UIKit

// MARK: - インジケーター生成

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
                    removeIndicator()
                }
            }
    }

    private func showActivityIndicator() {
        guard let window = getKeyWindow() else { return }

        // 既存のコンテナビューがある場合は削除する
        removeIndicator()

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
}

// MARK: - プレビュー

#if DEBUG

    #Preview {
        @Previewable @State var isVisible = false

        TabView {
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
