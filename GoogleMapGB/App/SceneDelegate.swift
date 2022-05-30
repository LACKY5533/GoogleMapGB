//
//  SceneDelegate.swift
//  GoogleMapGB
//
//  Created by LACKY on 16.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appSwitcherView: UIView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        appSwitcherView?.removeFromSuperview()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        let blurredImage = applyGaussianBlur(on: createScreenshotOfCurrentContext() ?? UIImage(), withBlurFactor: 4.5)
        appSwitcherView = UIImageView(image: blurredImage)
        self.window?.addSubview(appSwitcherView!)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func applyGaussianBlur(on image: UIImage, withBlurFactor blurFactor : CGFloat) -> UIImage? {
        guard let inputImage = CIImage(image: image) else {
            return nil
        }
        let gaussianFilter = CIFilter(name: "CIGaussianBlur")
        gaussianFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        gaussianFilter?.setValue(blurFactor, forKey: kCIInputRadiusKey)
        guard let outputImage = gaussianFilter?.outputImage else {
            return nil
        }
        return UIImage(ciImage: outputImage)
    }
    
    
    func createScreenshotOfCurrentContext() -> UIImage? {
        UIGraphicsBeginImageContext(self.window?.screen.bounds.size ?? CGSize())
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        self.window?.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

