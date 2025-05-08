//
//  HtmlRenderer.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import UIKit

class HtmlRenderer {
    
    static func renderHtml(html: String, in container: UIView) {
        print("Rendering HTML: \(html)")
        
        DispatchQueue.main.async {
            let parentWidth = container.frame.width
            let parentHeight = container.frame.height
            
            let initialContext = LayoutContext(isRoot: true, isParentHorizontal: false, parentWidthPx: Int(parentWidth), parentHeightPx: Int(parentHeight))
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let bodyElements: Elements = try doc.body()?.children() ?? Elements()
                
                for element in bodyElements {
                    print("Div style: \(try element.attr("style"))")
                    if let view = renderElement(element: element, contextInfo: initialContext) {
                        print("Adding view: \(try element.html())")
                        container.addSubview(view)
                    }
                }
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
    }
    
    private static func renderElement(element: Element, contextInfo: LayoutContext) -> UIView? {
        do {
            switch element.tagName() {
            case "div":
                if try element.children().isEmpty() && !element.text().isEmpty {
                    return renderText(element: element, contextInfo: contextInfo)
                }
                return renderDiv(element: element, contextInfo: contextInfo)
            case "img":
                return renderImage(element: element, contextInfo: contextInfo)
            case "p", "h1", "h2", "span":
                print("TextView1 style: \(try element.attr("style"))")
                print("TextView2 text: \(try element.text())")
                print("TextView3 color: \(contextInfo.color ?? "nil")")
                return renderText(element: element, contextInfo: contextInfo)
            default:
                print("Unsupported tag: <\(element.tagName())>")
                return nil
            }
        } catch {
            print("Error rendering element: \(error)")
            return nil
        }
    }
    
    private static func renderDiv(element: Element, contextInfo: LayoutContext) -> UIView {
        let layout = UIStackView()
        layout.axis = .vertical
        layout.spacing = 8
        
        do {
            let parentStyles = try StyleParser.parseStyle(element.attr("style"))
            print("Div styles: \(parentStyles)")
            
            let currentLayoutContext = SafeViewStyleApplier.applyLayoutStyles(to: layout, styles: parentStyles) //applyLayoutStyles(view: layout, styles: parentStyles, parentContext: contextInfo)
            
            if let display = parentStyles["display"], display.lowercased() == "flex" {
                if parentStyles["flex-direction"]?.lowercased() == "column" {
                    layout.axis = .vertical
                } else {
                    layout.axis = .horizontal
                }
            }
            
            let children = try element.children()
            for child in children {
                if let childView = renderElement(element: child, contextInfo: currentLayoutContext) {
                    layout.addArrangedSubview(childView)
                }
            }
        } catch {
            print("Error rendering div: \(error)")
        }
        
        return layout
    }
    
    private static func renderText(element: Element, contextInfo: LayoutContext) -> UIView {
        let label = UILabel()
        label.numberOfLines = 0
        
        do {
            label.text = try element.text()
            let styles = try StyleParser.parseStyle(element.attr("style"))
            SafeViewStyleApplier.applyTextStyles(to: label, styles: styles)
            SafeViewStyleApplier.applyLayoutStyles(to: label, styles: styles) //applyLayoutStyles(view: label, styles: styles, parentContext: contextInfo)
        } catch {
            print("Error rendering text: \(error)")
        }
        
        return label
    }
    
    private static func renderImage(element: Element, contextInfo: LayoutContext) -> UIView {
        let imageView = UIImageView()
        
        do {
            let src = try element.attr("src")
            let styles = try StyleParser.parseStyle(element.attr("style"))
            SafeViewStyleApplier.applyLayoutStyles(to: imageView, styles: styles) //applyLayoutStyles(view: imageView, styles: styles, parentContext: contextInfo)
            
            if !src.isEmpty, let url = URL(string: src) {
                // Load image asynchronously (e.g., using URLSession or a library like SDWebImage)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
            }
        } catch {
            print("Error rendering image: \(error)")
        }
        
        return imageView
    }
}
