// jQuery插件
// 无参数时，取得文本框中光标的位置
// 只有pos参数时，给文本框按照pos设定光标位置
// 同时有pos, text参数时，在指定pos位置插入text。
(function($) {
    $.fn.extend({
        textPosition: function( pos, text ){
            var elem = this[0];
            if (elem && (elem.tagName=="TEXTAREA"||elem.type.toLowerCase()=="text")) {
                // IE兼容代码
                if($('html').hasClass('lt-ie9')){
                    elem.focus();
                    var rng = document.selection.createRange();
                    var re = elem.createTextRange();
                    if( pos === undefined ){
                        var rc = re.duplicate();
                        re.moveToBookmark(rng.getBookmark());
                        rc.setEndPoint('EndToStart', re);
                        return rc.text.length;
                    }else if(typeof pos === "number" ){
                        re.moveStart("character",-elem.value.length);
                        re.moveStart("character", pos);
                        re.collapse(true);
                        re.select();
                        if( text === undefined ) {
                            return pos;
                        }
                    }
                // 其他浏览器兼容
                }else{
                    if( pos === undefined ){
                        return elem.selectionStart;
                    }else if(typeof pos === "number" ){
                        this.focus();
                        elem.selectionEnd = pos;
                        elem.selectionStart = pos;
                        if( text === undefined ) {
                            return pos;
                        }
                    }
                }
                if( text !== undefined ) {
                    var len = elem.value.length;
                    if(len<1 || pos<0) {
                        pos = 0;
                    } else if( pos>len ) {
                        pos = len;
                    }
                    var text1 = elem.value.substr(0,pos);
                    var text2 = elem.value.substr(pos);
                    pos += text.length;
                    elem.value = text1 + text + text2;
                    return this.textPosition(pos);
                } else {
                    // 就这个代码而言，无法到达这里
                    return 0;
                }
            }else{
                var indexn = 0;
                if( typeof pos === "number") {
                    indexn += pos;
                }
                return indexn;
            }
        }
    });
})(jQuery);
