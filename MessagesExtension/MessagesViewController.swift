//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Pablo Cambre on 9/26/16.
//  Copyright © 2016 Pablo Cambre. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }

    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    private func getQueryItem(from message: MSMessage) -> URLQueryItem? {
        guard let messageURL = message.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        let queryItem = queryItems.first(where: { (queryItem: URLQueryItem) -> Bool in
            queryItem.name == "rcv_mensaje"
        })
        return queryItem
    }
    
    private func getViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) ->UIViewController {
        if presentationStyle == .compact {
            return initStartViewController()
        }
        let message = conversation.selectedMessage
        if message != nil {
            let queryItem = getQueryItem(from: conversation.selectedMessage!)
            
            if queryItem != nil {
                return initReceiverViewController(with: (queryItem?.value)!)
            }
        }
        return initSenderViewController()
    
    }
    
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller = getViewController(for: conversation, with: presentationStyle)
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)

    }
    
    private func initReceiverViewController(with textMessage: String) -> UIViewController {
        // Instantiate a `BuildIceCreamViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ReceiverViewController.storyboardIdentifier) as? ReceiverViewController else { fatalError("Unable to instantiate a ReceiverViewController from the storyboard") }
        controller.message = textMessage
        return controller
    }
    
    private func initSenderViewController() -> UIViewController {
        // Instantiate a `BuildIceCreamViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SenderViewController.storyboardIdentifier) as? SenderViewController else { fatalError("Unable to instantiate a SenderViewController from the storyboard") }
        
        controller.delegate = self
        return controller
    }
    
    private func initStartViewController() -> UIViewController {
        // Instantiate a `BuildIceCreamViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: StartViewController.storyboardIdentifier) as? StartViewController else { fatalError("Unable to instantiate a StartViewController from the storyboard") }
        
        controller.delegate = self
        return controller
    }
    
    fileprivate func composeMessage(with textMessage: String, caption: String, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "rcv_mensaje", value: textMessage))
        components.queryItems = items
        
        //Creacion del message Layout, sin imagen
        let layout = MSMessageTemplateLayout()
        layout.caption = caption
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }

}

extension MessagesViewController: StartViewControllerDelegate {
    func startMessageSenderSelected(_ controller: StartViewController) {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: SenderViewControllerDelegate {
    func sendSelectedMessage(_ controller: SenderViewController, _ message: String) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        let message = composeMessage(with: message, caption: "Recibiste un mensaje desde una app!!!", session: conversation.selectedMessage?.session)
        
        // Mandar el mensaje a la conversacion
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
         dismiss()
    }
}
