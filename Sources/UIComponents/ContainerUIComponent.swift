//
//  ContainerUIComponent.swift
//
//
//  Created by Óscar Morales Vivó on 4/11/23.
//

import AutoLayoutHelpers
import SwiftUX
#if os(macOS)
import Cocoa

public typealias XXView = NSView
#elseif canImport(UIKit)
import UIKit

public typealias XXView = UIView
#endif

/**
 A UIComponent that whose main task is to contain another one.

 This class makes for easy setup of containment of a single view controller in charge of more complex UI. It can also
 be used for multiple modality content i.e. management of a loading operation.

 The class vends a `contentViewController` property that can be set to any view controller, as well as override points
 for the content's superview and enclosing layout area.
 */
open class ContainerUIComponent<Controller>: UIComponent<Controller> where Controller: ControllerProtocol {
    public var contentViewController: XXViewController? {
        willSet {
            guard let contentViewController, contentViewController != newValue else {
                return
            }

            if contentViewController.isViewLoaded {
                contentViewController.view.removeFromSuperview()
            }
            contentViewController.removeFromParent()
        }

        didSet {
            #if os(macOS)
            guard let contentViewController,
                  contentViewController != oldValue else {
                return
            }

            let contentView = contentViewController.view
            contentSuperview.add(subview: contentView)
            contentView.constraintsAgainstEnclosing(layoutArea: contentEnclosure).activate()

            addChild(contentViewController)
            #elseif canImport(UIKit)
            guard let contentViewController,
                  contentViewController != oldValue,
                  let contentView = contentViewController.view else {
                return
            }

            contentSuperview.add(subview: contentView)
            contentView.constraintsAgainstEnclosing(layoutArea: contentEnclosure).activate()

            addChild(contentViewController)
            contentViewController.didMove(toParent: self)
            #endif
        }
    }

    /**
     By default the view itself. Can override with any other subview in the view controller's hierarchy meant to be
     the superview of the content.
     */
    open var contentSuperview: XXView {
        view
    }

    /**
     By default the view itself. Can override with `safeLayoutAreaGuide` or any other subview/layout guide that is meant
     to directly enclose the content. Should be either `contentSuperview` or an element below it in the layout
     hierarchy.
     */
    open var contentEnclosure: LayoutArea {
        view
    }
}
