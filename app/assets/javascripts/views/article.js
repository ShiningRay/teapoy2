(function(){ 
  this.templates || (this.templates = {});
  this.templates["article"] = function anonymous(data) {
var a,article,b,button,details,div,h2,html,i,li,mark,ol,p,rt,s,sub,th,time,title,tr,u,ul,tt,col,hr,img,meta;a = function(){return __ck.tag('a', arguments);};article = function(){return __ck.tag('article', arguments);};b = function(){return __ck.tag('b', arguments);};button = function(){return __ck.tag('button', arguments);};details = function(){return __ck.tag('details', arguments);};div = function(){return __ck.tag('div', arguments);};h2 = function(){return __ck.tag('h2', arguments);};html = function(){return __ck.tag('html', arguments);};i = function(){return __ck.tag('i', arguments);};li = function(){return __ck.tag('li', arguments);};mark = function(){return __ck.tag('mark', arguments);};ol = function(){return __ck.tag('ol', arguments);};p = function(){return __ck.tag('p', arguments);};rt = function(){return __ck.tag('rt', arguments);};s = function(){return __ck.tag('s', arguments);};sub = function(){return __ck.tag('sub', arguments);};th = function(){return __ck.tag('th', arguments);};time = function(){return __ck.tag('time', arguments);};title = function(){return __ck.tag('title', arguments);};tr = function(){return __ck.tag('tr', arguments);};u = function(){return __ck.tag('u', arguments);};ul = function(){return __ck.tag('ul', arguments);};tt = function(){return __ck.tag('tt', arguments);};col = function(){return __ck.tag('col', arguments);};hr = function(){return __ck.tag('hr', arguments);};img = function(){return __ck.tag('img', arguments);};meta = function(){return __ck.tag('meta', arguments);};var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };var __extends = function(child, parent) {  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;  return child; };var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };
    var coffeescript, comment, doctype, h, ie, tag, text, yield, __ck, _ref, _ref2;
    if (data == null) {
      data = {};
    }
    if ((_ref = data.format) == null) {
      data.format = false;
    }
    if ((_ref2 = data.autoescape) == null) {
      data.autoescape = false;
    }
    __ck = {
      buffer: [],
      esc: function(txt) {
        if (data.autoescape) {
          return h(txt);
        } else {
          return String(txt);
        }
      },
      tabs: 0,
      repeat: function(string, count) {
        return Array(count + 1).join(string);
      },
      indent: function() {
        if (data.format) {
          return text(this.repeat('  ', this.tabs));
        }
      },
      tag: function(name, args) {
        var combo, i, _i, _len;
        combo = [name];
        for (_i = 0, _len = args.length; _i < _len; _i++) {
          i = args[_i];
          combo.push(i);
        }
        return tag.apply(data, combo);
      },
      render_idclass: function(str) {
        var c, classes, i, id, _i, _j, _len, _len2, _ref3;
        classes = [];
        _ref3 = str.split('.');
        for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
          i = _ref3[_i];
          if (__indexOf.call(i, '#') >= 0) {
            id = i.replace('#', '');
          } else {
            if (i !== '') {
              classes.push(i);
            }
          }
        }
        if (id) {
          text(" id=\"" + id + "\"");
        }
        if (classes.length > 0) {
          text(" class=\"");
          for (_j = 0, _len2 = classes.length; _j < _len2; _j++) {
            c = classes[_j];
            if (c !== classes[0]) {
              text(' ');
            }
            text(c);
          }
          return text('"');
        }
      },
      render_attrs: function(obj, prefix) {
        var k, v, _results;
        if (prefix == null) {
          prefix = '';
        }
        _results = [];
        for (k in obj) {
          v = obj[k];
          if (typeof v === 'boolean' && v) {
            v = k;
          }
          if (typeof v === 'function') {
            v = "(" + v + ").call(this);";
          }
          _results.push(typeof v === 'object' && !(v instanceof Array) ? this.render_attrs(v, prefix + k + '-') : v ? text(" " + (prefix + k) + "=\"" + (this.esc(v)) + "\"") : void 0);
        }
        return _results;
      },
      render_contents: function(contents) {
        var result;
        switch (typeof contents) {
          case 'string':
          case 'number':
          case 'boolean':
            return text(this.esc(contents));
          case 'function':
            if (data.format) {
              text('\n');
            }
            this.tabs++;
            result = contents.call(data);
            if (typeof result === 'string') {
              this.indent();
              text(this.esc(result));
              if (data.format) {
                text('\n');
              }
            }
            this.tabs--;
            return this.indent();
        }
      },
      render_tag: function(name, idclass, attrs, contents) {
        this.indent();
        text("<" + name);
        if (idclass) {
          this.render_idclass(idclass);
        }
        if (attrs) {
          this.render_attrs(attrs);
        }
        if (__indexOf.call(this.self_closing, name) >= 0) {
          text(' />');
          if (data.format) {
            text('\n');
          }
        } else {
          text('>');
          this.render_contents(contents);
          text("</" + name + ">");
          if (data.format) {
            text('\n');
          }
        }
        return null;
      }
    };
    tag = function() {
      var a, args, attrs, contents, idclass, name, _i, _len;
      name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      for (_i = 0, _len = args.length; _i < _len; _i++) {
        a = args[_i];
        switch (typeof a) {
          case 'function':
            contents = a;
            break;
          case 'object':
            attrs = a;
            break;
          case 'number':
          case 'boolean':
            contents = a;
            break;
          case 'string':
            if (args.length === 1) {
              contents = a;
            } else {
              if (a === args[0]) {
                idclass = a;
              } else {
                contents = a;
              }
            }
        }
      }
      return __ck.render_tag(name, idclass, attrs, contents);
    };
    yield = function(f) {
      var old_buffer, temp_buffer;
      temp_buffer = [];
      old_buffer = __ck.buffer;
      __ck.buffer = temp_buffer;
      f();
      __ck.buffer = old_buffer;
      return temp_buffer.join('');
    };
    h = function(txt) {
      return String(txt).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    };
    doctype = function(type) {
      if (type == null) {
        type = 'default';
      }
      text(__ck.doctypes[type]);
      if (data.format) {
        return text('\n');
      }
    };
    text = function(txt) {
      __ck.buffer.push(String(txt));
      return null;
    };
    comment = function(cmt) {
      text("<!--" + cmt + "-->");
      if (data.format) {
        return text('\n');
      }
    };
    coffeescript = function(param) {
      switch (typeof param) {
        case 'function':
          return script("" + __ck.coffeescript_helpers + "(" + param + ").call(this);");
        case 'string':
          return script({
            type: 'text/coffeescript'
          }, function() {
            return param;
          });
        case 'object':
          param.type = 'text/coffeescript';
          return script(param);
      }
    };
    ie = function(condition, contents) {
      __ck.indent();
      text("<!--[if " + condition + "]>");
      __ck.render_contents(contents);
      text("<![endif]-->");
      if (data.format) {
        return text('\n');
      }
    };
    __ck.doctypes = {"5":"<!DOCTYPE html>","default":"<!DOCTYPE html>","xml":"<?xml version=\"1.0\" encoding=\"utf-8\" ?>","transitional":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">","strict":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">","frameset":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">","1.1":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">","basic":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\" \"http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd\">","mobile":"<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.2//EN\" \"http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd\">","ce":"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"ce-html-1.0-transitional.dtd\">"};__ck.coffeescript_helpers = "var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };var __extends = function(child, parent) {  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;  return child; };var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };";__ck.self_closing = ["area","base","br","col","command","embed","hr","img","input","keygen","link","meta","param","source","track","wbr","basefont","frame"];(function(){
article(".cf.hentry.article", {
  id: "article_" + this.article.id
}, function() {
  return div("." + (this.top_post.class_names.join(' ')), {
    id: "" + this.article.id
  }, function() {
    div(".midcol." + this.top_post.rate_status, function() {
      div(".arrow.up", "");
      div(".score", "" + this.article.score);
      return div(".arrow.down", "");
    });
    if (this.article.title) {
      h2('.entry-title', function() {
        return a({
          href: "/" + this.article.group + "/" + this.article.title,
          rel: 'bookmark'
        }, "" + this.article.title);
      });
    }
    div('.entry-content', function() {
      return text(this.top_post.html);
    });
    return ul('.meta.cf', function() {
      li('.subscribe-button', function() {
        return a("" + this.article.subscribe_status, {
          href: "/" + this.article.group + "/" + this.article.id + "/" + this.article.subscribe_status
        }, this.article.subscribe_status === 'unsubscribe' ? "取消围观" : "围观");
      });
      li('.comment-status', function() {
        return a("comments", {
          id: "c-" + this.article.id,
          href: "/" + this.article.group + "/" + this.article.id
        }, this.article.posts_count > 1 ? "" + this.article.posts_count + "条评论" : "暂无评论");
      });
      li('.repost-button', function() {
        return a({
          href: "/articles/repost?post_id =" + this.top_post.id
        }, "转贴");
      });
      return li(".post-signature", function() {
        return div(".user-info", function() {
          div(".user-avatar", function() {
            return img(".avatar", {
              src: this.article.user.avatar_url,
              alt: "" + this.article.user.name
            });
          });
          div(".user-details", function() {
            if (this.top_post.anonymous) {
              return '匿名用户';
            } else {
              return a({
                'data-login': this.top_post.user.login,
                href: "/users/" + this.top_post.user.login
              }, this.top_post.user.name);
            }
          });
          return div(".user-action-time", function() {
            if (this.top_post.type === 'Repost') {
              text('转发于');
            } else {
              text('发布于');
            }
            a('.group', {
              'data-alias': this.article.group,
              href: '/' + this.article.group
            }, "" + this.article.group_name);
            return time(".relativetime", "" + this.article.time_ago_in_words);
          });
        });
      });
    });
  });
});
}).call(data);return __ck.buffer.join('');
};
}).call(this);