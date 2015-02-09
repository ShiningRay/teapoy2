(function(){ 
  this.templates || (this.templates = {});
  this.templates["comments"] = function anonymous(data) {
var a,article,b,body,dd,del,div,em,fieldset,form,html,i,label,li,ol,option,p,rt,s,script,small,span,style,sub,sup,textarea,th,tr,u,ul,area,col,hr,img,input;a = function(){return __ck.tag('a', arguments);};article = function(){return __ck.tag('article', arguments);};b = function(){return __ck.tag('b', arguments);};body = function(){return __ck.tag('body', arguments);};dd = function(){return __ck.tag('dd', arguments);};del = function(){return __ck.tag('del', arguments);};div = function(){return __ck.tag('div', arguments);};em = function(){return __ck.tag('em', arguments);};fieldset = function(){return __ck.tag('fieldset', arguments);};form = function(){return __ck.tag('form', arguments);};html = function(){return __ck.tag('html', arguments);};i = function(){return __ck.tag('i', arguments);};label = function(){return __ck.tag('label', arguments);};li = function(){return __ck.tag('li', arguments);};ol = function(){return __ck.tag('ol', arguments);};option = function(){return __ck.tag('option', arguments);};p = function(){return __ck.tag('p', arguments);};rt = function(){return __ck.tag('rt', arguments);};s = function(){return __ck.tag('s', arguments);};script = function(){return __ck.tag('script', arguments);};small = function(){return __ck.tag('small', arguments);};span = function(){return __ck.tag('span', arguments);};style = function(){return __ck.tag('style', arguments);};sub = function(){return __ck.tag('sub', arguments);};sup = function(){return __ck.tag('sup', arguments);};textarea = function(){return __ck.tag('textarea', arguments);};th = function(){return __ck.tag('th', arguments);};tr = function(){return __ck.tag('tr', arguments);};u = function(){return __ck.tag('u', arguments);};ul = function(){return __ck.tag('ul', arguments);};area = function(){return __ck.tag('area', arguments);};col = function(){return __ck.tag('col', arguments);};hr = function(){return __ck.tag('hr', arguments);};img = function(){return __ck.tag('img', arguments);};input = function(){return __ck.tag('input', arguments);};var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };var __extends = function(child, parent) {  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;  return child; };var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };
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
div(".comments_article", {
  id: "comments_article_" + this.article_id
}, function() {
  ul(".comments", function() {
    var comment, _i, _len, _ref, _results;
    a(".show_readed", {
      href: "/" + this.group_alias + "/" + this.article_id + "?read=full",
      style: "display:none;"
    }, "已经折叠了0个已读评论");
    _ref = this.comments;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      comment = _ref[_i];
      _results.push(li("." + (comment.class_names.join(' ')), {
        id: "post_" + comment.id,
        data: {
          "user_id": comment.user_id,
          "parent_id": comment.parent_id,
          "floor": comment.floor,
          "data": comment.created_at
        }
      }, function() {
        a({
          name: "floor-" + comment.floor
        });
        div(".midcol." + comment.rate_status, function() {
          div(".arrow.up", "");
          div(".score", "" + comment.score);
          return div(".arrow.down", "");
        });
        if (comment.anonymous) {
          img(".avatar.photo", {
            src: "/images/anonymous.png",
            alt: "匿名用户"
          });
        } else {
          img(".avatar." + comment.user.login, {
            src: comment.user.avatar_url,
            alt: comment.user.name
          });
        }
        div(".name", function() {
          if (comment.anonymous) {
            return span(".nickname.anonymous", "匿名人士");
          } else {
            span(".nickname", function() {
              return a(".user", {
                target: "_blank",
                "data-login": "" + comment.user.login,
                href: "/users/" + ("" + comment.user.login)
              }, "" + comment.user.name);
            });
            return span(".identity", function() {
              return a(".user", {
                target: "_blank",
                "data-login": "" + comment.user.login,
                href: "/users/" + ("" + comment.user.login)
              }, "@" + comment.user.login);
            });
          }
        });
        sup(".floor", "" + comment.floor);
        sup(".date", "" + comment.created_at);
        div(".body", "" + comment.html);
        return div(".operator", {
          style: "text-align:right;"
        }, function() {
          a(".reply", {
            href: "javascript:replyComment(" + comment.id + "," + this.article_id + "," + comment.floor + ")",
            "data-floor": comment.floor
          }, "回复");
          a(".repost", {
            href: "/articles/repost?post_id=" + comment.id
          }, "转贴");
          if (window.B.isLoggedIn() && current_user.login === comment.user.login) {
            return a({
              rel: "nofollow",
              data: {
                "remote": "true",
                "method": "delete",
                "confirm": "确定要删除吗?"
              },
              href: "/posts/" + comment.id
            }, "删除");
          }
        });
      }));
    }
    return _results;
  });
  if (window.B.isLoggedIn()) {
    return div(".reply-form", {
      id: "comment-form"
    }, function() {
      div(".avatar", function() {
        img({
          src: "" + (current_user.avatar_url.replace('small', 'thumb')),
          alt: "" + current_user.login
        });
        return div(".name", "" + current_user.name);
      });
      return form(".formtastic.post", {
        id: "new_post",
        method: "post",
        enctype: "multipart/form-data",
        action: "/" + this.group_alias + "/" + this.article_id + "/comments.html",
        "accept-charset": "UTF-8"
      }, function() {
        div({
          style: "margin:0;padding:0;display:inline"
        }, function() {
          input({
            type: "hidden",
            value: "✓",
            name: "utf8"
          });
          return input({
            type: "hidden",
            name: "authenticity_token"
          });
        });
        input({
          id: "from_xhr",
          type: "hidden",
          name: "from_xhr"
        });
        fieldset(".inputs", function() {
          return ol(function() {
            li(".optional.hidden", {
              id: "post_parent_id_input"
            }, function() {
              return input({
                id: "post_parent_id",
                type: "hidden",
                name: "post[parent_id]"
              });
            });
            div("", "", {
              id: "faceTitle"
            });
            li(".text.optional", {
              id: "post_content_input"
            }, function() {
              label({
                "for": "post_content"
              }, "内容");
              return textarea({
                id: "post_content",
                rows: 2,
                name: "post[content]"
              });
            });
            li(".commit", function() {
              return input(".create", {
                type: "submit",
                value: "回复",
                name: "commit",
                "data-disable-with": "..."
              });
            });
            li(".boolean.optional", {
              id: "post_anonymous_input"
            }, function() {
              input({
                type: "hidden",
                value: 0,
                name: "post[anonymous]"
              });
              return label({
                "for": "post_anonymous"
              }, function() {
                input({
                  id: "post_anonymous",
                  type: "checkbox",
                  value: 1,
                  name: "post[anonymous]"
                });
                return text("匿名");
              });
            });
            return li(".file.optional", {
              id: "post_picture_input"
            }, function() {
              label({
                "for": "post_picture"
              }, "图片");
              return input({
                id: "post_picture",
                type: "file",
                name: "post[picture]"
              });
            });
          });
        });
        return label(".reward", function() {
          text(" 打赏积分(每个帖子只能打赏一次)： ");
          return input({
            type: "text",
            name: "reward"
          });
        });
      });
    });
  } else {
    return div(".reply-form", {
      id: "comment-form"
    }, function() {
      return div("", "", function() {
        text("请");
        a(".need-login", {
          href: "/login"
        }, "登录");
        text("或");
        a({
          href: "/signup"
        }, "注册");
        return text("后留言");
      });
    });
  }
});
}).call(data);return __ck.buffer.join('');
};
}).call(this);