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

public class MainWindowController: NSWindowController, NSWindowDelegate
{
    public private( set ) var file: MachOFile?
    
    public override var windowNibName: NSNib.Name?
    {
        return NSNib.Name( NSStringFromClass( type( of: self ) ) )
    }
    
    override public func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.window?.titlebarAppearsTransparent = true
        self.window?.titleVisibility            = .hidden
        self.window?.delegate                   = self
    }
    
    @IBAction public func openDocument( _ sender: Any? )
    {
        let panel                      = NSOpenPanel()
        panel.canSelectHiddenExtension = true
        panel.canChooseFiles           = true
        panel.canChooseDirectories     = false
        panel.allowsMultipleSelection  = false
        
        panel.beginSheetModal( for: self.window! )
        {
            res in
            
            if( res != .OK || panel.url == nil )
            {
                self.window?.close()
                
                return
            }
            
            var alert: NSAlert?
            
            do
            {
                try self.file = MachOFile( url: panel.url! )
            }
            catch MachOFile.Error.FileDoesNotExist( let file )
            {
                alert              = NSAlert()
                alert?.messageText = "File does not exist: \(file)"
            }
            catch MachOFile.Error.FileIsADirectory( let file )
            {
                alert              = NSAlert()
                alert?.messageText = "File is a directory: \(file)"
            }
            catch MachOFile.Error.FileIsNotReadable( let file )
            {
                alert              = NSAlert()
                alert?.messageText = "File is not readable: \(file)"
            }
            catch MachOFile.Error.InvalidFormat( let file )
            {
                alert              = NSAlert()
                alert?.messageText = "File is invalid: \(file)"
            }
            catch
            {
                alert              = NSAlert()
                alert?.messageText = "Unknown error"
            }
            
            alert?.runModal()
        }
    }
}
