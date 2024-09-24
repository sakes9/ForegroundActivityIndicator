// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import UIKit

// MARK: - アクティビティーインジケーター

struct UIActivityIndicatorModifier: ViewModifier {
    private var isVisible: Bool // アクティビティインジケーターの表示フラグ
    private let backgroundColor: UIColor // 背景色
    private let indicatorColor: UIColor // インジケーターの色

    /// イニシャライザ
    /// - Parameters:
    ///   - isVisible: インジケーター表示フラグ
    ///   - backgroundColor: 背景色
    ///   - indicatorColor: インジケーター色
    init(isVisible: Bool, backgroundColor: UIColor, indicatorColor: UIColor) {
        self.isVisible = isVisible
        self.backgroundColor = backgroundColor
        self.indicatorColor = indicatorColor
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

    /// アクティビティインジケーターを表示するメソッド
    /// `isVisible`が`true`の場合に呼び出され、アクティビティインジケーターを表示します。
    private func showActivityIndicator() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }

        // 最前面のビューコントローラを見つける
        let topViewController = findTopViewController(rootViewController)

        // 既存のコンテナビューがある場合は削除する
        if let existingContainerView = topViewController.view.subviews.first(where: { $0 is UIActivityIndicatorOverlayContainerView }) {
            existingContainerView.removeFromSuperview()
        }

        // コンテナビューを作成
        let containerView = UIActivityIndicatorOverlayContainerView(frame: topViewController.view.bounds)
        containerView.backgroundColor = backgroundColor // 外部から設定された背景色と透明度を適用
        containerView.isUserInteractionEnabled = true // ユーザーインタラクションをブロック

        // アクティビティインジケーターを作成
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = indicatorColor // 外部から設定されたインジケーターの色を適用
        activityIndicator.startAnimating()

        // アクティビティインジケーターの位置を設定
        activityIndicator.center = containerView.center

        // コンテナビューにアクティビティインジケーターを追加
        containerView.addSubview(activityIndicator)

        // トップビューコントローラのビューにコンテナビューを追加
        topViewController.view.addSubview(containerView)
    }

    /// アクティビティインジケーターを削除するメソッド
    /// `isVisible`が`false`の場合に呼び出され、アクティビティインジケーターを削除する。
    private func removeActivityIndicator() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }

        let topViewController = findTopViewController(rootViewController)

        // コンテナビューを削除
        if let containerView = topViewController.view.subviews.first(where: { $0 is UIActivityIndicatorOverlayContainerView }) {
            containerView.removeFromSuperview()
        }
    }

    /// 最前面のビューコントローラを見つけるヘルパーメソッド
    /// - Parameter rootViewController: ルートビューコントローラ
    /// - Returns: 最前面のビューコントローラ
    private func findTopViewController(_ rootViewController: UIViewController) -> UIViewController {
        // プレゼンテッドビューコントローラがある場合は再帰的に呼び出す
        if let presentedViewController = rootViewController.presentedViewController {
            return findTopViewController(presentedViewController)
        }

        // ナビゲーションコントローラーがある場合は、最後にプッシュされたビューコントローラを返す
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController ?? navigationController
        }

        // タブバーコントローラーがある場合は、選択されているビューコントローラを返す
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController ?? tabBarController
        }

        return rootViewController
    }
}

// MARK: - コンテナビュー

class UIActivityIndicatorOverlayContainerView: UIView {}

// MARK: - ビュー拡張

public extension View {
    /// アクティビティインジケーターをオーバーレイ表示するカスタムモディファイア
    /// - Parameters:
    ///   - isVisible: アクティビティインジケーターの表示フラグ
    ///   - backgroundColor: 背景色と透明度を指定
    ///   - indicatorColor: インジケーターの色を指定
    /// - Returns: 修正されたビュー
    func activityIndicator(isVisible: Bool,
                           backgroundColor: UIColor = UIColor.clear,
                           indicatorColor: UIColor = .darkGray) -> some View {
        modifier(UIActivityIndicatorModifier(isVisible: isVisible, backgroundColor: backgroundColor, indicatorColor: indicatorColor))
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
            .activityIndicator(isVisible: isVisible,
                               backgroundColor: .gray.withAlphaComponent(0.5),
                               indicatorColor: .white)
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
