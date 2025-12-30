@_exported import NVActivityIndicatorView
import SwiftUI
import UIKit

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

    /// Lottieアニメーションをオーバーレイ表示するカスタムモディファイア
    /// - Parameters:
    ///   - isVisible: インジケーターの表示フラグ
    ///   - fileName: Lottieファイル名（拡張子なし）
    ///   - size: アニメーションのサイズ
    ///   - text: インジケーター下に表示するテキスト
    ///   - backgroundColor: 背景色と透明度を指定
    ///   - textColor: テキストの色を指定
    /// - Returns: 修正されたビュー
    func lottieIndicator(
        isVisible: Bool,
        fileName: String,
        size: CGSize = CGSize(width: 100, height: 100),
        text: String? = nil,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = .gray
    ) -> some View {
        modifier(
            UILottieIndicatorModifier(
                isVisible: isVisible,
                fileName: fileName,
                size: size,
                text: text,
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        )
    }
}
