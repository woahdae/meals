/*----------------------------------------------------------------------------------------------
 * Simple Wysiwym Editor for jQuery
 * Copyright © 2009, Michael Shepanski
 * http://pushingkarma.com/ - All rights reserved.
 * Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States.
 * http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 *
 *  Instructions:
 *   1. If using this with the Django's 
 *--------------------------------------------------------------------------------------------- */
(function($) {
	$.fn.wysiwym = function(markupSet, id) {
        if (id == null) { id = 'wysiwymEditor'; }
        
        // Setup the Wysiwym Editor
        return this.each(function() {
            var textarea = this;                   // Javascript Textarea Object
            var jqTextarea = $(this);              // jQuery Textarea Object
            var markup = new markupSet(textarea);  // Markup Set to use for this Textarea
            
            // Initialize the Basic Editor HTML
            $(jqTextarea).wrap("<div class='wysiwymEditor' id='"+id+"'></div>");
            var header = $("<div class='wysiwymHeader'></div>").insertBefore(jqTextarea);
            var footer = $("<div class='wysiwymFooter'></div>").insertAfter(jqTextarea);
            var editor = header.parent();
            
            // Add the Specfied Buttons
            $.each(markup.buttons, function() {
                var cssClass = this.name.toLowerCase().replace(' ', '');
                var button = $("<div class='button button-"+cssClass+"' title='"+this.name+"'><span>"+this.name+"</span></div>");
                var data = { editor:editor, textarea:textarea, button:button, args:this.args };
                button.bind('click', data, this.callback);
                header.append(button);
            });
            
        });
        
	};
})(jQuery);


/*----------------------------------------------------------------------------------------------
 * Textarea Object
 *   This can used used for some or all of your textarea modifications. It will keep track of
 *   the the current text and cursor positions. The general idea is to keep track of the
 *   textarea in terms of Line objects.  A line object contains a lineType and supporting text.
 *--------------------------------------------------------------------------------------------- */
function WysiwymTextarea(textarea) {
    this.NEWLINE = "\n";                  // Newline Character specified to Browser
    var NONE = { prefix: '' }             // Line Type NONE
    var lines = new Array();              // Array Line objects { type, text, selected }
    var cursor = {                        // Internal Cursor Object { start, end }
        start: { line:0, position:0 },    // Cursor Start Position { line, position }
        end: { line:0, position:0 },      // Cursor End Position { line, position }
        scroll: 0                         // Current Scroll Position   
    }
    
    /*-------------------------------------------------------------------
     * Simple Public Functions
     *------------------------------------------------------------------ */
    this.getCursor = function()           { return cursor; }
    this.getLines = function()            { return lines; }
    this.getNumLines = function()         { return lines.length; }
    this.getLine = function(lineNum)      { return lines[lineNum]; }
    this.getSelectionRange = function()   { return [cursor.start.line, cursor.end.line]; }
    
    /*-------------------------------------------------------------------
     * @public getSelection: Return the current selected text.
     *------------------------------------------------------------------ */
    this.getSelection = function() {
        var selection = "";
        for (i in lines) {
            var text = lines[i].text;
            if ((i == cursor.start.line) && (i == cursor.end.line))
                return text.substring(cursor.start.position, cursor.end.position);
            if (i == cursor.start.line)
                selection = selection + text.substring(cursor.start.position, text.length);
            if ((i > cursor.start.line) && (i < cursor.end.line))
                selection = selection + text;
            if (i == cursor.end.line)
                selection = selection + text.substring(0, cursor.end.position)
        }
        return selection;
    }
    
    /*-------------------------------------------------------------------
     * @public getSelection: Return the length of Selection text
     *------------------------------------------------------------------ */
    this.getSelectionLength = function() {
        var selection = this.getSelection();
        return selection.length;
    }
    
    /*-------------------------------------------------------------------
     * @public hasPrefix: Return true if the current selection has the
     *   specified prefix text. NOTE: Does not work with return lines.
     *------------------------------------------------------------------ */
    this.selectionHasPrefix = function(prefixText) {
        var lineText = lines[cursor.start.line].text;
        var start = cursor.start.position - prefixText.length;
        if (start < 0) { return false; }
        if (lineText.substring(start, cursor.start.position) != prefixText) { return false; }
        return true;
    }
    
    /*-------------------------------------------------------------------
     * @public hasPrefix: Return true if the current selection has the
     *   specified suffix text. NOTE: Does not work with return lines.
     *------------------------------------------------------------------ */
    this.selectionHasSuffix = function(suffixText) {
        var lineText = lines[cursor.end.line].text;
        var end = cursor.end.position + suffixText.length;
        if (end > lineText.length) { return false; }
        if (lineText.substring(cursor.end.position, end) != suffixText) { return false; }
        return true;
    }
    
    /*-------------------------------------------------------------------
     * @public prependToSelection: Insert the specified text at at the cursor
     *   start position and make it selected.
     *------------------------------------------------------------------ */
    this.prependToSelection = function(insertText) {
        var lineText = lines[cursor.start.line].text;
        var newText = lineText.substring(0, cursor.start.position) +
            insertText + lineText.substring(cursor.start.position, lineText.length);
        lines[cursor.start.line].text = newText;
        // Update Class Variables
        if (cursor.start.line == cursor.end.line)
            cursor.end.position += insertText.length;
    }
    
    /*-------------------------------------------------------------------
     * @public appendToSelection: Insert the specified text at at the cursor
     *   end position and make it selected.
     *------------------------------------------------------------------ */
    this.appendToSelection = function(insertText) {
        var lineText = lines[cursor.end.line].text;
        var newText = lineText.substring(0, cursor.end.position) +
            insertText + lineText.substring(cursor.end.position, lineText.length);
        lines[cursor.end.line].text = newText;
        // Update Class Variables
        cursor.end.position += insertText.length;
    }
    
    /*-------------------------------------------------------------------
     * @public insertSelectionPrefix: Insert the specified text at at the cursor
     *   start position.  NOTE: This does not work with return lines.
     *------------------------------------------------------------------ */
    this.insertSelectionPrefix = function(prefixText) {
        var lineText = lines[cursor.start.line].text;
        var newText = lineText.substring(0, cursor.start.position) +
            prefixText + lineText.substring(cursor.start.position, lineText.length);
        lines[cursor.start.line].text = newText;
        // Update Class Variables
        cursor.start.position += prefixText.length;
        if (cursor.start.line == cursor.end.line)
            cursor.end.position += prefixText.length;
    }
    
    /*-------------------------------------------------------------------
     * @public insertSelectionSuffix: Insert the specified text at at the cursor
     *   end position.  NOTE: This does not work with return lines.
     *------------------------------------------------------------------ */
    this.insertSelectionSuffix = function(suffixText) {
        var lineText = lines[cursor.end.line].text;
        var newText = lineText.substring(0, cursor.end.position) +
            suffixText + lineText.substring(cursor.end.position, lineText.length);
        lines[cursor.end.line].text = newText;
    }
    
    /*-------------------------------------------------------------------
     * @public removePrefix: Remove the specified prefix text if it
     *   matches with the passed in value.  Returns boolean True it
     *   was successful, False otherwise.
     *------------------------------------------------------------------ */
    this.removeSelectionPrefix = function(prefixText) {
        if (this.selectionHasPrefix(prefixText)) {
            var lineText = lines[cursor.start.line].text;
            var start = cursor.start.position - prefixText.length;
            var newText = lineText.substring(0, start) +
                lineText.substring(cursor.start.position, lineText.length);
            lines[cursor.start.line].text = newText;
            // Update Class Variables
            cursor.start.position -= prefixText.length;
            if (cursor.start.line == cursor.end.line)
                cursor.end.position -= prefixText.length;
            return true;
        }
        return false;
    }
    
    /*-------------------------------------------------------------------
     * @public removeSuffix: Remove the specified suffix text if it
     *   matches with the passed in value.  Returns boolean True it
     *   was successful, False otherwise.
     *------------------------------------------------------------------ */
    this.removeSelectionSuffix = function(suffixText) {
        if (this.selectionHasSuffix(suffixText)) {
            var lineText = lines[cursor.end.line].text;
            var end = cursor.end.position + suffixText.length;
            var newText = lineText.substring(0, cursor.end.position) +
                lineText.substring(end, lineText.length);
            lines[cursor.end.line].text = newText;
            return true;
        }
        return false;
    }
    
    /*-------------------------------------------------------------------
     * @public isWrapped: Return True if the selection is wrapped
     *   in the specified prefix and suffix text.  Otherwise False.
     *   NOTE: Does not work with return lines.
     *------------------------------------------------------------------ */
    this.selectionIsWrapped = function(prefixText, suffixText) {
        if (suffixText == null) { suffixText = prefixText; }
        return ((this.selectionHasPrefix(prefixText)) && (this.selectionHasSuffix(suffixText)))
    }
    
    /*-------------------------------------------------------------------
     * @public wrap: Wrap the cursor or currently selected text
     *   with the specified newTextBefore and newTextAfter.
     *------------------------------------------------------------------ */
    this.wrapSelection = function(prefixText, suffixText) {
        if (suffixText == null) { suffixText = prefixText; }
        this.insertSelectionPrefix(prefixText);
        this.insertSelectionSuffix(suffixText);
    }
    
    /*-------------------------------------------------------------------
     * @public unwrap: Unwrap the selection by removeing the prefix
     *   and suffix text specified.  Returns boolean True it
     *   was successful, False otherwise.
     *------------------------------------------------------------------ */
    this.unwrapSelection = function(prefixText, suffixText) {
        if (suffixText == null) { suffixText = prefixText; }
        if ((this.selectionHasPrefix(prefixText)) && (this.selectionHasSuffix(suffixText))) {
            this.removeSelectionPrefix(prefixText);
            this.removeSelectionSuffix(suffixText);
            return true;
        }
        return false;
    }
    
    /*-------------------------------------------------------------------
     * @public insertLinePrefix: Return True if the line has the
     *   specified prefix.
     *------------------------------------------------------------------ */
    this.lineHasPrefix = function(lineNum, prefixText) {
        return lines[lineNum].text.substring(0, prefixText.length) == prefixText;
    }
    
    /*-------------------------------------------------------------------
     * @public insertLinePrefix: Add the Prefix to the specified line.
     *------------------------------------------------------------------ */
    this.insertLinePrefix = function(lineNum, prefixText) {
        var lineText = lines[lineNum].text;
        var newText = prefixText + lineText.substring(0, cursor.start.position) +
            lineText.substring(cursor.start.position, lineText.length);
        lines[lineNum].text = newText;
        // Update Class Variables
        if (lineNum == cursor.start.line)
            cursor.start.position += prefixText.length;
        if (lineNum == cursor.end.line)
            cursor.end.position += prefixText.length;
    }
    
    /*-------------------------------------------------------------------
     * @public removePrefix: Remove the specified prefix text if it
     *   matches with the passed in value.  Returns boolean True it
     *   was successful, False otherwise.
     *------------------------------------------------------------------ */
    this.removeLinePrefix = function(lineNum, prefixText) {
        if (this.lineHasPrefix(lineNum, prefixText)) {
            var lineText = lines[lineNum].text;
            var newText = lineText.substring(prefixText.length, lineText.length);
            lines[lineNum].text = newText;
            // Update Class Variables
            if (lineNum == cursor.start.line)
                cursor.start.position -= prefixText.length;
            if (lineNum == cursor.end.line)
                cursor.end.position -= prefixText.length;
            return true;
        }
        return false;
    }
    
    /*-------------------------------------------------------------------
     * @public insertLineSuffix: Append the suffix to the end of the
     *   specified line.
     *------------------------------------------------------------------ */
    this.insertLineSuffix = function(lineNum, suffixText) {
        var lineText = lines[lineNum].text;
        var newText = lineText.substring(0, cursor.start.position) +
            lineText.substring(cursor.start.position, lineText.length) + suffixText;
        lines[lineNum].text = newText;
    }
    
    /*-------------------------------------------------------------------
     * @public insertLinePrefix: Return True if all lines in the
     *   selection have the specified prefix.
     *------------------------------------------------------------------ */
    this.selectionLinesHavePrefix = function(prefixText) {
        for (var i=cursor.start.line; i<=cursor.end.line; i++)
            if (!this.lineHasPrefix(i, prefixText))
                return false;
        return true;
    }
    
    /*-------------------------------------------------------------------
     * @public insertLinePrefix: Add the Prefix Text to all lines in
     *   the selection.
     *------------------------------------------------------------------ */
    this.insertSelectionLinesPrefix = function(prefixText) {
        for (var i=cursor.start.line; i<=cursor.end.line; i++)
            this.insertLinePrefix(i, prefixText);
    }
    
    /*-------------------------------------------------------------------
     * @public insertLinePrefix: Add the Prefix Text to all lines in
     *   the selection.
     *------------------------------------------------------------------ */
    this.removeSelectionLinesPrefix = function(prefixText) {
        for (var i=cursor.start.line; i<=cursor.end.line; i++)
            this.removeLinePrefix(i, prefixText);
    }
    
    /*-------------------------------------------------------------------
     * @public getTextareaProperties: Return the global textarea
     *   properties (NOT by Line).  This returns the a Map containing:
     *   { text, cursorStart, cursorEnd, selectionLength, scroll }
     *------------------------------------------------------------------ */
    this.getTextareaProperties = function() {
        var text = ""               // Global Textarea Value
        var cursorStart = 0;        // Cursor Start Position (chars from beginning of textarea)
        var cursorEnd = 0;          // Cursor End Position (chars from beginning of textarea)
        var selectionLength = 0;    // Selection Length (total chars)
        var lineStart = 0;
        for (i in lines) {
            text += lines[i].text;
            if (i == cursor.start.line)
                cursorStart = lineStart + cursor.start.position;
            if (i == cursor.end.line)
                cursorEnd = lineStart + cursor.end.position;
            lineStart += lines[i].text.length;
        }
        var selectionLength = cursorEnd - cursorStart;
        return { text:text, cursorStart:cursorStart, cursorEnd:cursorEnd,
            selectionLength:selectionLength, scroll:cursor.scroll }
    }
    
    /*-------------------------------------------------------------------
     * @public update: Update the HTML textarea to reflect all changes
     *   made within this class.  This is generally the last step in
     *   defining a markup button.
     *------------------------------------------------------------------ */
    this.update = function() {
        var textProperties = this.getTextareaProperties();
        // Update the Textarea
        $(textarea).val(textProperties.text);
        if (textarea.createTextRange) {
            range = textarea.createTextRange();
            range.collapse(true);
            range.moveStart('character', textProperties.cursorStart); 
            range.moveEnd('character', textProperties.selectionLength);
            range.select();
        } else if (textarea.setSelectionRange) {
            textarea.setSelectionRange(textProperties.cursorStart, textProperties.cursorEnd);
        }
        textarea.scrollTop = textProperties.scroll;
        textarea.focus();
    }
    
    /*-------------------------------------------------------------------
     * @private getCursorProperties: Returns a Map object containing the
     *   current the current cursor properties for scroll position,
     *   cursor position and selection length.
     *------------------------------------------------------------------ */
    function getCursorProperties() {
        textarea.focus();
        var scroll = textarea.scrollTop;   // Current Scroll Position
        var position = 0;                  // Current Cursor Position
        var selection = "";                // Current Selection Length
        if (document.selection) {
            // Internet Explorer
            selection = document.selection.createRange().text;  
            if ($.browser.msie) {
                var range = document.selection.createRange();
                var rangeCopy = range.duplicate();
                rangeCopy.moveToElementText(textarea);
                position = -1;
                while(rangeCopy.inRange(range)) {
                    rangeCopy.moveStart('character');
                    position++;
                }
            } else {
                // Opera
                position = textarea.selectionStart;
            }
        } else {
            // Mozilla
            position = textarea.selectionStart;  
            selection = $(textarea).val().substring(position, textarea.selectionEnd);
        }
        return {scroll: scroll, position: position, length: selection.length}
    }
    
    /*-------------------------------------------------------------------
     * @private getTextareaProperties: Updates the class variables for
     *   lines in the Textarea and cursor start and end position
     *   (in terms of lines).
     *------------------------------------------------------------------ */
    function setupPropertiesByLine() {
        var text = $(textarea).val();                              // Initial Textarea Value
        var cursorInfo = getCursorProperties();                    // Cursor Properties
        var cursorStart = cursorInfo.position;                     // Global Cursor Start Position
        var cursorEnd = cursorInfo.position + cursorInfo.length;   // Global Cursor End Position
        // Parse the Current Textarea
        var num = 0;               // Iter Line Number
        var lineStart = 0;         // Iter Position
        var lastLine = false;      // Flag Set on Last Line
        while (!lastLine) {
            // Find the Line Ending Position
            var lineEnd = text.indexOf("\n", lineStart);
            var charEnd = lineEnd;
            if (lineEnd >= 0) { lineEnd += 1; }
            else { lastLine = true; lineEnd = charEnd = text.length; }
            // Get the Line Properties
            var lineText = text.substring(lineStart, lineEnd);
            var selected = (cursorStart <= charEnd) && (cursorEnd >= lineStart)
            lines[num] = { text:lineText, selected:selected };
            // Update the Cursor Information
            if ((cursorStart >= lineStart) && (cursorStart <= charEnd))
                cursor.start = { line: num, position:cursorStart-lineStart };
            if ((cursorEnd >= lineStart) && (cursorEnd <= lineEnd))
                cursor.end = { line:num, position:cursorEnd-lineStart};
            // Update Properties for Next Line
            lineStart = lineEnd;
            num += 1;
        }
        // Save the Scroll Position
        cursor.scroll = cursorInfo.scroll;
    }

    /*--- Main ---*/
    setupPropertiesByLine();
    
}

/*----------------------------------------------------------------------
 * Additional Javascript Prototypes
 *-------------------------------------------------------------------- */
String.prototype.trim  = function() { return this.replace(/^\s+|\s+$/g,""); }
String.prototype.ltrim = function() { return this.replace(/^\s+/,""); }
String.prototype.rtrim = function() { return this.replace(/\s+$/,""); }

