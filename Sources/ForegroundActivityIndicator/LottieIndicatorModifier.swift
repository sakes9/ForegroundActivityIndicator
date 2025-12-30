import Lottie
import SwiftUI
import UIKit

// MARK: - Lottieビュー生成

private func createLottieView(
    fileName: String,
    size: CGSize
) -> LottieAnimationView {
    let animationView = LottieAnimationView(name: fileName, bundle: .main)
    animationView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.play()
    return animationView
}

// MARK: - モディファイア

struct UILottieIndicatorModifier: ViewModifier {
    private let isVisible: Bool
    private let fileName: String
    private let size: CGSize
    private let text: String?
    private let backgroundColor: UIColor
    private let textColor: UIColor

    init(
        isVisible: Bool,
        fileName: String,
        size: CGSize,
        text: String?,
        backgroundColor: UIColor,
        textColor: UIColor
    ) {
        self.isVisible = isVisible
        self.fileName = fileName
        self.size = size
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: isVisible) {
                if isVisible {
                    showLottieIndicator()
                } else {
                    removeIndicator()
                }
            }
    }

    private func showLottieIndicator() {
        guard let window = getKeyWindow() else { return }

        removeIndicator()

        let lottieView = createLottieView(fileName: fileName, size: size)
        let containerView = createContainerView(
            frame: window.bounds,
            indicatorView: lottieView,
            labelOffset: size.height / 2 + 10,
            text: text,
            textColor: textColor,
            backgroundColor: backgroundColor
        )

        window.addSubview(containerView)
    }
}

// MARK: - プレビュー

#if DEBUG

    #Preview {
        @Previewable @State var isVisible = false

        VStack {
            Image(systemName: "1.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .lottieIndicator(
            isVisible: isVisible,
            fileName: "sample_lottie_icon", // パッケージ内ではbundle扱いになるので、プレビューで表示する場合はコード上の.mainをbundleに変更してください
            size: CGSize(width: 200, height: 200),
            text: "ローディング...",
            backgroundColor: .gray.withAlphaComponent(0.5),
            textColor: .white
        )
        .onAppear {
            isVisible = true
        }
    }

#endif
