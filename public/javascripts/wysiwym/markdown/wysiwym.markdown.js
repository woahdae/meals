/* ---------------------------------------------------------------------------
 * Markdown Button Set for PKs Wysiwym Editor
 *
 * Copyright © 2009, Michael Shepanski
 * http://pushingkarma.com/ - All rights reserved.
 * Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States.
 * http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 * Instructions:
 *   1. Follow all instructions from the main ajaxcomments and
 *      jquery.wysiwym.js files.
 *      
 *   2. Add the following references to html template containing Django's
 *      Comment application:
 *        * ajaxcomments/wysiwym/markdown/wysiwym.markdown.css
 *        * ajaxcomments/wysiwym/markdown/wysiwym.markdown.js
 *        * ajaxcomments/wysiwym/markdown/showdown.js
 *---------------------------------------------------------------------------- */

function WysiwymMarkdown(textarea) {
    
    // Public Variables
    this.name = 'Markdown';          // Markup Language Name
    this.buttonLink  = buttonLink;   // Link Callback
    this.genericSpan = genericSpan;  // Public Callback function
    this.genericLine = genericLine;  // Public Callback function
    
    // Private Markdown Variables
    var prefixRegex = /^[\s\>\.\*\+\-0-9]+\s/;
    var lineTypes = {
        BULLET: { prefix: '* ' },
        NUMBER: { prefix: '# ' },
        QUOTE:  { prefix: '> ' },
        CODE:   { prefix: '    ' },
    };
    
    // Required Variable (Buttons to Display)
    this.buttons = [
        { name: 'Bold',        callback: this.genericSpan, args: {wrapText: '**', dummyText: 'strong text'} },
        { name: 'Italic',      callback: this.genericSpan, args: {wrapText: '_',  dummyText: 'emphasized text'} },
        { name: 'Link',        callback: this.buttonLink },
        { name: 'Bullet List', callback: this.genericLine, args: {lineType: lineTypes.BULLET} },
        { name: 'Quote',       callback: this.genericLine, args: {lineType: lineTypes.QUOTE} },
        { name: 'Code',        callback: this.genericLine, args: {lineType: lineTypes.CODE} },
    ];
    
    // Register Return Line (for auto-indent)
    $(textarea).bind('keydown', function(event) {
        if (event.keyCode == 13) { return autoIndent(); }
    });
    
    /*-------------------------------------------------------------
     * buttonLink:  Wraps the Selection with the specified
     *   markdown link syntax, [This link](http://example.net/)
     *------------------------------------------------------------- */
    function buttonLink(event) {
        var wtext = new WysiwymTextarea(textarea);
        var cursor = wtext.getCursor();
        var linkUrl = null;
        // Set the LinkUrl if this is a proper Link
        if (wtext.selectionIsWrapped("\[", "](")) {
            var linkSuffix = wtext.getLine(cursor.end.line).text.substring(cursor.end.position);
            var matches = linkSuffix.match(/^\]\(.*?\)/);
            if (matches != null)
                linkUrl = matches[0].substring(2, matches[0].length-1);
        }
        // Update the Textarea
        if (linkUrl != null) {
            wtext.unwrapSelection("[", "]("+linkUrl+")");
        } else if (wtext.getSelectionLength() == 0) {
            wtext.appendToSelection("Link Title");
            wtext.wrapSelection("[", "](http://example.com)");
        } else {
            wtext.wrapSelection("[", "](http://example.com)");
        }
        wtext.update();
    }
    
    /*-------------------------------------------------------------
     * genericSpan:  Wraps the Selection with the specified
     *   args.wrapText defined on the button.
     *------------------------------------------------------------- */
    function genericSpan(event) {
        var wrapText = event.data.args.wrapText;
        var dummyText = event.data.args.dummyText;
        var wtext = new WysiwymTextarea(textarea);
        // Update the Textarea
        if (wtext.selectionIsWrapped(wrapText)) {
            wtext.unwrapSelection(wrapText);
        } else if (wtext.getSelectionLength() == 0) {
            wtext.appendToSelection(dummyText);
            wtext.wrapSelection(wrapText);
        } else {
            wtext.wrapSelection(wrapText);
        }
        wtext.update();
    }
    
    /*-------------------------------------------------------------
     * buttonLine:  Starts the Lines with the specified
     *   args.prefixText defined on the button definition
     *------------------------------------------------------------- */
    function genericLine(event) {
        var lineType = event.data.args.lineType;
        var wtext = new WysiwymTextarea(textarea);
        // Update the Textarea
        if (!wtext.selectionLinesHavePrefix(lineType.prefix)) {
            // Not all Lines are LineType; Remove all prefixes and Add LineType's prefix
            var selectRange = wtext.getSelectionRange();
            for (i=selectRange[0]; i<=selectRange[1]; i++) {
                var lineInfo = getLineProperties(wtext, i);
                wtext.removeLinePrefix(i, lineInfo.prefix);
                wtext.insertLinePrefix(i, lineType.prefix);
            }
            // Check Blank Lines Around Selection
            assertBlockWrap(wtext, lineType);
        } else {
            // All Lines are LineType; Remove all prefixes
            wtext.removeSelectionLinesPrefix(lineType.prefix);
        }
        wtext.update();
    }
    
    /*-------------------------------------------------------------
     * getLineProperties:  Returns information about a single line
     *------------------------------------------------------------- */
    function getLineProperties(wtext, lineNum) {
        var line = wtext.getLine(lineNum);
        for (var key in lineTypes) {
            var type = lineTypes[key];
            var prefix = type.prefix;
            if (wtext.lineHasPrefix(lineNum, prefix)) {
                var fullPrefix = line.text.match(prefixRegex)[0];
                return { prefix:fullPrefix, text:line.text.substring(prefix, line.text.length) };
            }
        }
        return { prefix:'', text:line.text };
    }
    
    /*-------------------------------------------------------------
     * assertBlockWrap:  Asserts the selected lines have a line
     *   with the specified prefix before and after.  If not, a
     *   blank line is inserted to ensure the lineType is applied
     *   correctly.
     *------------------------------------------------------------- */
    function assertBlockWrap(wtext, lineType) {
        var cursor = wtext.getCursor();
        // Check the Previous Line
        if (cursor.start.line != 0) {
            var lineInfo = getLineProperties(wtext, cursor.start.line-1);
            if ((lineInfo.prefix != lineType.prefix) && (lineInfo.text.trim() != ""))
                wtext.insertLinePrefix(cursor.start.line, wtext.NEWLINE);
        }
        // Check the Next Line
        if (cursor.end.line != wtext.getNumLines()-1) {
            var lineInfo = getLineProperties(wtext, cursor.end.line+1);
            if ((lineInfo.prefix != lineType.prefix) && (lineInfo.text.trim() != ""))
                wtext.insertLineSuffix(cursor.end.line, wtext.NEWLINE);
        }
    }
    
    /*-------------------------------------------------------------
     * autoIndent:  Auto-Indent the next line when enter pushed.
     *------------------------------------------------------------- */
    function autoIndent() {
        var wtext = new WysiwymTextarea(textarea);
        var cursor = wtext.getCursor();
        var lineNum = cursor.start.line;
        var line = wtext.getLine(lineNum);
        var lineText = line.text.substring(0, cursor.start.position);
        // Make sure there is Prefix Text
        var matches = lineText.match(prefixRegex);
        if (matches == null) { return true; }
        // If there is no Actual Text, Clear the line
        var prefix = matches[0].substring(0, matches[0].length);
        if (prefix.length == cursor.start.position) {
            // Return on Blank Indented Line (Clear Prefix)
            wtext.removeLinePrefix(lineNum, prefix);
            wtext.update();
            return true;
        } else {
            // Normal Auto-Indent
            wtext.insertSelectionPrefix(wtext.NEWLINE + prefix);
            wtext.update();
            return false;
        }
    }
   
}

