/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2017 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa

@NSApplicationMain public class ApplicationDelegate: NSObject, NSApplicationDelegate
{
    var mainWindowControllers = [ MainWindowController ]()
    
    public func applicationDidFinishLaunching( _ notification: Notification )
    {
        NotificationCenter.default.addObserver( self, selector: #selector( windowWillClose ), name: NSWindow.willCloseNotification, object: nil )
        self.newDocument( nil )
        
        Preferences.shared.lastStart = Date()
    }
    
    public func applicationWillTerminate( _ notification: Notification )
    {
        NotificationCenter.default.removeObserver( self )
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        return false
    }
    
    @objc func windowWillClose( _ notification: Notification )
    {
        guard let window = ( notification.object as AnyObject? ) as? NSWindow else
        {
            return
        }
        
        self.mainWindowControllers = self.mainWindowControllers.filter{ $0 != window.windowController }
    }
    
    @IBAction public func newDocument( _ sender: Any? )
    {
        let controller = MainWindowController()
        
        if( Preferences.shared.lastStart == nil )
        {
            controller.window?.center()
        }
        
        self.mainWindowControllers.append( controller )
        controller.window?.makeKeyAndOrderFront( sender )
        controller.openDocument( sender )
    }
    
    @IBAction public func openDocument( _ sender: Any? )
    {
        self.newDocument( sender )
    }
}
