import UIKit

// MARK: - コンテナビュー

class IndicatorOverlayContainerView: UIView {}

// MARK: - 共通関数

func getKeyWindow() -> UIWindow? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first(where: { $0.isKeyWindow })
    else {
        return nil
    }
    return window
}

func createContainerView(
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

func removeIndicator() {
    guard let window = getKeyWindow() else { return }

    if let containerView = window.subviews.first(where: { $0 is IndicatorOverlayContainerView }) {
        containerView.removeFromSuperview()
    }
}
