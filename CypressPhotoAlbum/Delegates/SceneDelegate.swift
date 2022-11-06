//
//  SceneDelegate.swift
//  CypressPhotoAlbum
//
//  Created by Decagon on 02/11/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
       window = UIWindow(frame: windowScene.coordinateSpace.bounds)
       window?.windowScene = windowScene
       window?.rootViewController = PhotoViewController()
       window?.makeKeyAndVisible()
    }

}

