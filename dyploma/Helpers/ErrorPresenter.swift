//
//  ErrorPresenter.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 14.05.23.
//


import UIKit

enum ErrorPresenter {
  static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
    weak var weakViewController = viewController
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Отменить", style: .default, handler: dismissAction))
      weakViewController?.present(alertController, animated: true)
    }
  }
}
