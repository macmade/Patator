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

import Foundation

@objc public class MachOFile: NSObject
{
    public enum Error: Swift.Error
    {
        case FileDoesNotExist( String )
        case FileIsADirectory( String )
        case FileIsNotReadable( String )
        case InvalidFormat( String )
    }
    
    public convenience init( url: URL ) throws
    {
        var isDir: ObjCBool = false
        
        if( FileManager.default.fileExists( atPath: url.path, isDirectory: &isDir ) == false )
        {
            throw Error.FileDoesNotExist( url.path )
        }
        
        if( isDir.boolValue )
        {
            throw Error.FileIsADirectory( url.path )
        }
        
        do
        {
            try self.init( data: Data( contentsOf: url ), fromURL: url )
        }
        catch
        {
            throw Error.FileIsNotReadable( url.path )
        }
    }
    
    public init( data: Data, fromURL: URL ) throws
    {
        if( data.count < 4 )
        {
            throw Error.FileIsNotReadable( fromURL.path )
        }
        
        if
        (
               ( data[ 0 ] != 0xCA || data[ 1 ] != 0xFE || data[ 2 ] != 0xBA || data[ 3 ] != 0xBE )
            && ( data[ 0 ] != 0xCF || data[ 1 ] != 0xFA || data[ 2 ] != 0xED || data[ 3 ] != 0xFE )
        )
        {
            throw Error.InvalidFormat( fromURL.path )
        }
    }
}
