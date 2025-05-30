< script type = "text/javascript"
src = "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" > < /script> < script >
  MathJax.Hub.Config({
    config: ["MMLorHTML.js"],
    extensions: ["tex2jax.js"],
    jax: ["input/TeX"],
    tex2jax: {
      inlineMath: [
        ['$', '$'],
        ["\\(", "\\)"]
      ],
      displayMath: [
        ['$$', '$$'],
        ["\\[", "\\]"]
      ],
      processEscapes: false
    },
    TeX: {
      extensions: ["AMSmath.js", "AMSsymbols.js"],
      TagSide: "right",
      TagIndent: ".8em",
      MultLineWidth: "85%",
      equationNumbers: {
        autoNumber: "AMS",
      },
      unicode: {
        fonts: "STIXGeneral,'Arial Unicode MS'"
      }
    },
    showProcessingMessages: false
  }); < /script> < script type = "text/javascript"
charset = "utf-8"
src = "https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.2/raphael-min.js" > < /script> < script type = "text/javascript"
charset = "utf-8"
src = "https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.7.0/underscore-min.js" > < /script> < script type = "text/javascript"
charset = "utf-8"
src = "https://cdnjs.cloudflare.com/ajax/libs/js-sequence-diagrams/1.0.4/sequence-diagram-min.js" > < /script> < script type = "text/javascript" >
  // flowchart, v1.3.4
  // Copyright (c)2014 Adriano Raiano (adrai).
  // Distributed under MIT license
  // http://adrai.github.io/flowchart.js
  ! function() {
    function a(b, c) {
      if (!b || "function" == typeof b) return c;
      var d = {};
      for (var e in c) d[e] = c[e];
      for (e in b) b[e] && (d[e] = "object" == typeof d[e] ? a(d[e], b[e]) : b[e]);
      return d
    }

    function b(a, b) {
      if ("function" == typeof Object.create) a.super_ = b, a.prototype = Object.create(b.prototype, {
        constructor: {
          value: a,
          enumerable: !1,
          writable: !0,
          configurable: !0
        }
      });
      else {
        a.super_ = b;
        var c = function() {};
        c.prototype = b.prototype, a.prototype = new c, a.prototype.constructor = a
      }
    }

    function c(a, b, c) {
      var d, e, f = "M{0},{1}";
      for (d = 2, e = 2 * c.length + 2; e > d; d += 2) f += " L{" + d + "},{" + (d + 1) + "}";
      var g = [b.x, b.y];
      for (d = 0, e = c.length; e > d; d++) g.push(c[d].x), g.push(c[d].y);
      var h = a.paper.path(f, g);
      h.attr("stroke", a.options["element-color"]), h.attr("stroke-width", a.options["line-width"]);
      var i = a.options.font,
        j = a.options["font-family"],
        k = a.options["font-weight"];
      return i && h.attr({
        font: i
      }), j && h.attr({
        "font-family": j
      }), k && h.attr({
        "font-weight": k
      }), h
    }

    function d(a, b, c, d) {
      var e, f;
      "[object Array]" !== Object.prototype.toString.call(c) && (c = [c]);
      var g = "M{0},{1}";
      for (e = 2, f = 2 * c.length + 2; f > e; e += 2) g += " L{" + e + "},{" + (e + 1) + "}";
      var h = [b.x, b.y];
      for (e = 0, f = c.length; f > e; e++) h.push(c[e].x), h.push(c[e].y);
      var i = a.paper.path(g, h);
      i.attr({
        stroke: a.options["line-color"],
        "stroke-width": a.options["line-width"],
        "arrow-end": a.options["arrow-end"]
      });
      var j = a.options.font,
        k = a.options["font-family"],
        l = a.options["font-weight"];
      if (j && i.attr({
          font: j
        }), k && i.attr({
          "font-family": k
        }), l && i.attr({
          "font-weight": l
        }), d) {
        var m = !1,
          n = a.paper.text(0, 0, d),
          o = !1,
          p = c[0];
        b.y === p.y && (o = !0);
        var q = 0,
          r = 0;
        m ? (q = b.x > p.x ? b.x - (b.x - p.x) / 2 : p.x - (p.x - b.x) / 2, r = b.y > p.y ? b.y - (b.y - p.y) / 2 : p.y - (p.y - b.y) / 2, o ? (q -= n.getBBox().width / 2, r -= a.options["text-margin"]) : (q += a.options["text-margin"], r -= n.getBBox().height / 2)) : (q = b.x, r = b.y, o ? (q += a.options["text-margin"] / 2, r -= a.options["text-margin"]) : (q += a.options["text-margin"] / 2, r += a.options["text-margin"])), n.attr({
          "text-anchor": "start",
          "font-size": a.options["font-size"],
          fill: a.options["font-color"],
          x: q,
          y: r
        }), j && n.attr({
          font: j
        }), k && n.attr({
          "font-family": k
        }), l && n.attr({
          "font-weight": l
        })
      }
      return i
    }

    function e(a, b, c, d, e, f, g, h) {
      var i, j, k, l, m, n = {
        x: null,
        y: null,
        onLine1: !1,
        onLine2: !1
      };
      return i = (h - f) * (c - a) - (g - e) * (d - b), 0 === i ? n : (j = b - f, k = a - e, l = (g - e) * j - (h - f) * k, m = (c - a) * j - (d - b) * k, j = l / i, k = m / i, n.x = a + j * (c - a), n.y = b + j * (d - b), j > 0 && 1 > j && (n.onLine1 = !0), k > 0 && 1 > k && (n.onLine2 = !0), n)
    }

    function f(a, b) {
      b = b || {}, this.paper = new Raphael(a), this.options = r.defaults(b, q), this.symbols = [], this.lines = [], this.start = null
    }

    function g(a, b, c) {
      this.chart = a, this.group = this.chart.paper.set(), this.symbol = c, this.connectedTo = [], this.symbolType = b.symbolType, this.flowstate = b.flowstate || "future", this.next_direction = b.next && b.direction_next ? b.direction_next : void 0, this.text = this.chart.paper.text(0, 0, b.text), b.key && (this.text.node.id = b.key + "t"), this.text.node.setAttribute("class", this.getAttr("class") + "t"), this.text.attr({
        "text-anchor": "start",
        x: this.getAttr("text-margin"),
        fill: this.getAttr("font-color"),
        "font-size": this.getAttr("font-size")
      });
      var d = this.getAttr("font"),
        e = this.getAttr("font-family"),
        f = this.getAttr("font-weight");
      d && this.text.attr({
        font: d
      }), e && this.text.attr({
        "font-family": e
      }), f && this.text.attr({
        "font-weight": f
      }), b.link && this.text.attr("href", b.link), b.target && this.text.attr("target", b.target);
      var g = this.getAttr("maxWidth");
      if (g) {
        for (var h = b.text.split(" "), i = "", j = 0, k = h.length; k > j; j++) {
          var l = h[j];
          this.text.attr("text", i + " " + l), i += this.text.getBBox().width > g ? "\n" + l : " " + l
        }
        this.text.attr("text", i.substring(1))
      }
      if (this.group.push(this.text), c) {
        var m = this.getAttr("text-margin");
        c.attr({
          fill: this.getAttr("fill"),
          stroke: this.getAttr("element-color"),
          "stroke-width": this.getAttr("line-width"),
          width: this.text.getBBox().width + 2 * m,
          height: this.text.getBBox().height + 2 * m
        }), c.node.setAttribute("class", this.getAttr("class")), b.link && c.attr("href", b.link), b.target && c.attr("target", b.target), b.key && (c.node.id = b.key), this.group.push(c), c.insertBefore(this.text), this.text.attr({
          y: c.getBBox().height / 2
        }), this.initialize()
      }
    }

    function h(a, b) {
      var c = a.paper.rect(0, 0, 0, 0, 20);
      b = b || {}, b.text = b.text || "Start", g.call(this, a, b, c)
    }

    function i(a, b) {
      var c = a.paper.rect(0, 0, 0, 0, 20);
      b = b || {}, b.text = b.text || "End", g.call(this, a, b, c)
    }

    function j(a, b) {
      var c = a.paper.rect(0, 0, 0, 0);
      b = b || {}, g.call(this, a, b, c)
    }

    function k(a, b) {
      var c = a.paper.rect(0, 0, 0, 0);
      b = b || {}, g.call(this, a, b, c), c.attr({
        width: this.text.getBBox().width + 4 * this.getAttr("text-margin")
      }), this.text.attr({
        x: 2 * this.getAttr("text-margin")
      });
      var d = a.paper.rect(0, 0, 0, 0);
      d.attr({
        x: this.getAttr("text-margin"),
        stroke: this.getAttr("element-color"),
        "stroke-width": this.getAttr("line-width"),
        width: this.text.getBBox().width + 2 * this.getAttr("text-margin"),
        height: this.text.getBBox().height + 2 * this.getAttr("text-margin"),
        fill: this.getAttr("fill")
      }), b.key && (d.node.id = b.key + "i");
      var e = this.getAttr("font"),
        f = this.getAttr("font-family"),
        h = this.getAttr("font-weight");
      e && d.attr({
        font: e
      }), f && d.attr({
        "font-family": f
      }), h && d.attr({
        "font-weight": h
      }), b.link && d.attr("href", b.link), b.target && d.attr("target", b.target), this.group.push(d), d.insertBefore(this.text), this.initialize()
    }

    function l(a, b) {
      b = b || {}, g.call(this, a, b), this.textMargin = this.getAttr("text-margin"), this.text.attr({
        x: 3 * this.textMargin
      });
      var d = this.text.getBBox().width + 4 * this.textMargin,
        e = this.text.getBBox().height + 2 * this.textMargin,
        f = this.textMargin,
        h = e / 2,
        i = {
          x: f,
          y: h
        },
        j = [{
          x: f - this.textMargin,
          y: e
        }, {
          x: f - this.textMargin + d,
          y: e
        }, {
          x: f - this.textMargin + d + 2 * this.textMargin,
          y: 0
        }, {
          x: f - this.textMargin + 2 * this.textMargin,
          y: 0
        }, {
          x: f,
          y: h
        }],
        k = c(a, i, j);
      k.attr({
        stroke: this.getAttr("element-color"),
        "stroke-width": this.getAttr("line-width"),
        fill: this.getAttr("fill")
      }), b.link && k.attr("href", b.link), b.target && k.attr("target", b.target), b.key && (k.node.id = b.key), k.node.setAttribute("class", this.getAttr("class")), this.text.attr({
        y: k.getBBox().height / 2
      }), this.group.push(k), k.insertBefore(this.text), this.initialize()
    }

    function m(a, b) {
      b = b || {}, g.call(this, a, b), this.textMargin = this.getAttr("text-margin"), this.yes_direction = "bottom", this.no_direction = "right", b.yes && b.direction_yes && b.no && !b.direction_no ? "right" === b.direction_yes ? (this.no_direction = "bottom", this.yes_direction = "right") : (this.no_direction = "right", this.yes_direction = "bottom") : b.yes && !b.direction_yes && b.no && b.direction_no ? "right" === b.direction_no ? (this.yes_direction = "bottom", this.no_direction = "right") : (this.yes_direction = "right", this.no_direction = "bottom") : (this.yes_direction = "bottom", this.no_direction = "right"), this.yes_direction = this.yes_direction || "bottom", this.no_direction = this.no_direction || "right", this.text.attr({
        x: 2 * this.textMargin
      });
      var d = this.text.getBBox().width + 3 * this.textMargin;
      d += d / 2;
      var e = this.text.getBBox().height + 2 * this.textMargin;
      e += e / 2, e = Math.max(.5 * d, e);
      var f = d / 4,
        h = e / 4;
      this.text.attr({
        x: f + this.textMargin / 2
      });
      var i = {
          x: f,
          y: h
        },
        j = [{
          x: f - d / 4,
          y: h + e / 4
        }, {
          x: f - d / 4 + d / 2,
          y: h + e / 4 + e / 2
        }, {
          x: f - d / 4 + d,
          y: h + e / 4
        }, {
          x: f - d / 4 + d / 2,
          y: h + e / 4 - e / 2
        }, {
          x: f - d / 4,
          y: h + e / 4
        }],
        k = c(a, i, j);
      k.attr({
        stroke: this.getAttr("element-color"),
        "stroke-width": this.getAttr("line-width"),
        fill: this.getAttr("fill")
      }), b.link && k.attr("href", b.link), b.target && k.attr("target", b.target), b.key && (k.node.id = b.key), k.node.setAttribute("class", this.getAttr("class")), this.text.attr({
        y: k.getBBox().height / 2
      }), this.group.push(k), k.insertBefore(this.text), this.initialize()
    }

    function n(a) {
      function b(a) {
        var b = a.indexOf("(") + 1,
          c = a.indexOf(")");
        return b >= 0 && c >= 0 ? d.symbols[a.substring(0, b - 1)] : d.symbols[a]
      }

      function c(a) {
        var b = "next",
          c = a.indexOf("(") + 1,
          d = a.indexOf(")");
        return c >= 0 && d >= 0 && (b = D.substring(c, d), b.indexOf(",") < 0 && "yes" !== b && "no" !== b && (b = "next, " + b)), b
      }
      a = a || "", a = a.trim();
      for (var d = {
          symbols: {},
          start: null,
          drawSVG: function(a, b) {
            function c(a) {
              if (g[a.key]) return g[a.key];
              switch (a.symbolType) {
                case "start":
                  g[a.key] = new h(e, a);
                  break;
                case "end":
                  g[a.key] = new i(e, a);
                  break;
                case "operation":
                  g[a.key] = new j(e, a);
                  break;
                case "inputoutput":
                  g[a.key] = new l(e, a);
                  break;
                case "subroutine":
                  g[a.key] = new k(e, a);
                  break;
                case "condition":
                  g[a.key] = new m(e, a);
                  break;
                default:
                  return new Error("Wrong symbol type!")
              }
              return g[a.key]
            }
            var d = this;
            this.diagram && this.diagram.clean();
            var e = new f(a, b);
            this.diagram = e;
            var g = {};
            ! function n(a, b, f) {
              var g = c(a);
              return d.start === a ? e.startWith(g) : b && f && !b.pathOk && (b instanceof m ? (f.yes === a && b.yes(g), f.no === a && b.no(g)) : b.then(g)), g.pathOk ? g : (g instanceof m ? (a.yes && n(a.yes, g, a), a.no && n(a.no, g, a)) : a.next && n(a.next, g, a), g)
            }(this.start), e.render()
          },
          clean: function() {
            this.diagram.clean()
          }
        }, e = [], g = 0, n = 1, o = a.length; o > n; n++)
        if ("\n" === a[n] && "\\" !== a[n - 1]) {
          var p = a.substring(g, n);
          g = n + 1, e.push(p.replace(/\\\n/g, "\n"))
        }
      g < a.length && e.push(a.substr(g));
      for (var q = 1, r = e.length; r > q;) {
        var s = e[q];
        s.indexOf(": ") < 0 && s.indexOf("(") < 0 && s.indexOf(")") < 0 && s.indexOf("->") < 0 && s.indexOf("=>") < 0 ? (e[q - 1] += "\n" + s, e.splice(q, 1), r--) : q++
      }
      for (; e.length > 0;) {
        var t = e.splice(0, 1)[0];
        if (t.indexOf("=>") >= 0) {
          var u, v = t.split("=>"),
            w = {
              key: v[0],
              symbolType: v[1],
              text: null,
              link: null,
              target: null,
              flowstate: null
            };
          if (w.symbolType.indexOf(": ") >= 0 && (u = w.symbolType.split(": "), w.symbolType = u[0], w.text = u[1]), w.text && w.text.indexOf(":>") >= 0 ? (u = w.text.split(":>"), w.text = u[0], w.link = u[1]) : w.symbolType.indexOf(":>") >= 0 && (u = w.symbolType.split(":>"), w.symbolType = u[0], w.link = u[1]), w.symbolType.indexOf("\n") >= 0 && (w.symbolType = w.symbolType.split("\n")[0]), w.link) {
            var x = w.link.indexOf("[") + 1,
              y = w.link.indexOf("]");
            x >= 0 && y >= 0 && (w.target = w.link.substring(x, y), w.link = w.link.substring(0, x - 1))
          }
          if (w.text && w.text.indexOf("|") >= 0) {
            var z = w.text.split("|");
            w.text = z[0], w.flowstate = z[1].trim()
          }
          d.symbols[w.key] = w
        } else if (t.indexOf("->") >= 0)
          for (var A = t.split("->"), B = 0, C = A.length; C > B; B++) {
            var D = A[B],
              E = b(D),
              F = c(D),
              G = null;
            if (F.indexOf(",") >= 0) {
              var H = F.split(",");
              F = H[0], G = H[1].trim()
            }
            if (d.start || (d.start = E), C > B + 1) {
              var I = A[B + 1];
              E[F] = b(I), E["direction_" + F] = G, G = null
            }
          }
      }
      return d
    }
    Array.prototype.indexOf || (Array.prototype.indexOf = function(a) {
      "use strict";
      if (null === this) throw new TypeError;
      var b = Object(this),
        c = b.length >>> 0;
      if (0 === c) return -1;
      var d = 0;
      if (arguments.length > 0 && (d = Number(arguments[1]), d != d ? d = 0 : 0 !== d && 1 / 0 != d && d != -1 / 0 && (d = (d > 0 || -1) * Math.floor(Math.abs(d)))), d >= c) return -1;
      for (var e = d >= 0 ? d : Math.max(c - Math.abs(d), 0); c > e; e++)
        if (e in b && b[e] === a) return e;
      return -1
    }), Array.prototype.lastIndexOf || (Array.prototype.lastIndexOf = function(a) {
      "use strict";
      if (null === this) throw new TypeError;
      var b = Object(this),
        c = b.length >>> 0;
      if (0 === c) return -1;
      var d = c;
      arguments.length > 1 && (d = Number(arguments[1]), d != d ? d = 0 : 0 !== d && d != 1 / 0 && d != -(1 / 0) && (d = (d > 0 || -1) * Math.floor(Math.abs(d))));
      for (var e = d >= 0 ? Math.min(d, c - 1) : c - Math.abs(d); e >= 0; e--)
        if (e in b && b[e] === a) return e;
      return -1
    }), String.prototype.trim || (String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/g, "")
    });
    var o = this,
      p = {};
    "undefined" != typeof module && module.exports ? module.exports = p : o.flowchart = o.flowchart || p;
    var q = {
        x: 0,
        y: 0,
        "line-width": 3,
        "line-length": 50,
        "text-margin": 10,
        "font-size": 14,
        "font-color": "black",
        "line-color": "black",
        "element-color": "black",
        fill: "white",
        "yes-text": "yes",
        "no-text": "no",
        "arrow-end": "block",
        "class": "flowchart",
        symbols: {
          start: {},
          end: {},
          condition: {},
          inputoutput: {},
          operation: {},
          subroutine: {}
        }
      },
      r = {
        defaults: a,
        inherits: b
      };
    f.prototype.handle = function(a) {
      this.symbols.indexOf(a) <= -1 && this.symbols.push(a);
      var b = this;
      return a instanceof m ? (a.yes = function(c) {
        return a.yes_symbol = c, a.no_symbol && (a.pathOk = !0), b.handle(c)
      }, a.no = function(c) {
        return a.no_symbol = c, a.yes_symbol && (a.pathOk = !0), b.handle(c)
      }) : a.then = function(c) {
        return a.next = c, a.pathOk = !0, b.handle(c)
      }, a
    }, f.prototype.startWith = function(a) {
      return this.start = a, this.handle(a)
    }, f.prototype.render = function() {
      var a, b = 0,
        c = 0,
        d = 0,
        e = 0,
        f = 0,
        g = 0;
      for (d = 0, e = this.symbols.length; e > d; d++) a = this.symbols[d], a.width > b && (b = a.width), a.height > c && (c = a.height);
      for (d = 0, e = this.symbols.length; e > d; d++) a = this.symbols[d], a.shiftX(this.options.x + (b - a.width) / 2 + this.options["line-width"]), a.shiftY(this.options.y + (c - a.height) / 2 + this.options["line-width"]);
      for (this.start.render(), d = 0, e = this.symbols.length; e > d; d++) a = this.symbols[d], a.renderLines();
      for (f = this.maxXFromLine, d = 0, e = this.symbols.length; e > d; d++) {
        a = this.symbols[d];
        var h = a.getX() + a.width,
          i = a.getY() + a.height;
        h > f && (f = h), i > g && (g = i)
      }
      this.paper.setSize(f + this.options["line-width"], g + this.options["line-width"])
    }, f.prototype.clean = function() {
      if (this.paper) {
        var a = this.paper.canvas;
        a.parentNode.removeChild(a)
      }
    }, g.prototype.getAttr = function(a) {
      if (!this.chart) return void 0;
      var b, c = this.chart.options ? this.chart.options[a] : void 0,
        d = this.chart.options.symbols ? this.chart.options.symbols[this.symbolType][a] : void 0;
      return this.chart.options.flowstate && this.chart.options.flowstate[this.flowstate] && (b = this.chart.options.flowstate[this.flowstate][a]), b || d || c
    }, g.prototype.initialize = function() {
      this.group.transform("t" + this.getAttr("line-width") + "," + this.getAttr("line-width")), this.width = this.group.getBBox().width, this.height = this.group.getBBox().height
    }, g.prototype.getCenter = function() {
      return {
        x: this.getX() + this.width / 2,
        y: this.getY() + this.height / 2
      }
    }, g.prototype.getX = function() {
      return this.group.getBBox().x
    }, g.prototype.getY = function() {
      return this.group.getBBox().y
    }, g.prototype.shiftX = function(a) {
      this.group.transform("t" + (this.getX() + a) + "," + this.getY())
    }, g.prototype.setX = function(a) {
      this.group.transform("t" + a + "," + this.getY())
    }, g.prototype.shiftY = function(a) {
      this.group.transform("t" + this.getX() + "," + (this.getY() + a))
    }, g.prototype.setY = function(a) {
      this.group.transform("t" + this.getX() + "," + a)
    }, g.prototype.getTop = function() {
      var a = this.getY(),
        b = this.getX() + this.width / 2;
      return {
        x: b,
        y: a
      }
    }, g.prototype.getBottom = function() {
      var a = this.getY() + this.height,
        b = this.getX() + this.width / 2;
      return {
        x: b,
        y: a
      }
    }, g.prototype.getLeft = function() {
      var a = this.getY() + this.group.getBBox().height / 2,
        b = this.getX();
      return {
        x: b,
        y: a
      }
    }, g.prototype.getRight = function() {
      var a = this.getY() + this.group.getBBox().height / 2,
        b = this.getX() + this.group.getBBox().width;
      return {
        x: b,
        y: a
      }
    }, g.prototype.render = function() {
      if (this.next) {
        var a = this.getAttr("line-length");
        if ("right" === this.next_direction) {
          var b = this.getRight();
          if (this.next.getLeft(), !this.next.isPositioned) {
            this.next.setY(b.y - this.next.height / 2), this.next.shiftX(this.group.getBBox().x + this.width + a);
            var c = this;
            ! function e() {
              for (var b, d = !1, f = 0, g = c.chart.symbols.length; g > f; f++) {
                b = c.chart.symbols[f];
                var h = Math.abs(b.getCenter().x - c.next.getCenter().x);
                if (b.getCenter().y > c.next.getCenter().y && h <= c.next.width / 2) {
                  d = !0;
                  break
                }
              }
              d && (c.next.setX(b.getX() + b.width + a), e())
            }(), this.next.isPositioned = !0, this.next.render()
          }
        } else {
          var d = this.getBottom();
          this.next.getTop(), this.next.isPositioned || (this.next.shiftY(this.getY() + this.height + a), this.next.setX(d.x - this.next.width / 2), this.next.isPositioned = !0, this.next.render())
        }
      }
    }, g.prototype.renderLines = function() {
      this.next && (this.next_direction ? this.drawLineTo(this.next, "", this.next_direction) : this.drawLineTo(this.next))
    }, g.prototype.drawLineTo = function(a, b, c) {
      this.connectedTo.indexOf(a) < 0 && this.connectedTo.push(a);
      var f, g = this.getCenter().x,
        h = this.getCenter().y,
        i = (this.getTop(), this.getRight()),
        j = this.getBottom(),
        k = this.getLeft(),
        l = a.getCenter().x,
        m = a.getCenter().y,
        n = a.getTop(),
        o = a.getRight(),
        p = (a.getBottom(), a.getLeft()),
        q = g === l,
        r = h === m,
        s = m > h,
        t = h > m,
        u = g > l,
        v = l > g,
        w = 0,
        x = this.getAttr("line-length"),
        y = this.getAttr("line-width");
      if (c && "bottom" !== c || !q || !s)
        if (c && "right" !== c || !r || !v)
          if (c && "left" !== c || !r || !u)
            if (c && "right" !== c || !q || !t)
              if (c && "right" !== c || !q || !s)
                if (c && "bottom" !== c || !u)
                  if (c && "bottom" !== c || !v)
                    if (c && "right" === c && u) f = d(this.chart, i, [{
                      x: i.x + x / 2,
                      y: i.y
                    }, {
                      x: i.x + x / 2,
                      y: n.y - x / 2
                    }, {
                      x: n.x,
                      y: n.y - x / 2
                    }, {
                      x: n.x,
                      y: n.y
                    }], b), this.rightStart = !0, a.topEnd = !0, w = i.x + x / 2;
                    else if (c && "right" === c && v) f = d(this.chart, i, [{
        x: n.x,
        y: i.y
      }, {
        x: n.x,
        y: n.y
      }], b), this.rightStart = !0, a.topEnd = !0, w = i.x + x / 2;
      else if (c && "bottom" === c && q && t) f = d(this.chart, j, [{
        x: j.x,
        y: j.y + x / 2
      }, {
        x: i.x + x / 2,
        y: j.y + x / 2
      }, {
        x: i.x + x / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.bottomStart = !0, a.topEnd = !0, w = j.x + x / 2;
      else if ("left" === c && q && t) {
        var z = k.x - x / 2;
        p.x < k.x && (z = p.x - x / 2), f = d(this.chart, k, [{
          x: z,
          y: k.y
        }, {
          x: z,
          y: n.y - x / 2
        }, {
          x: n.x,
          y: n.y - x / 2
        }, {
          x: n.x,
          y: n.y
        }], b), this.leftStart = !0, a.topEnd = !0, w = k.x
      } else "left" === c && (f = d(this.chart, k, [{
        x: n.x + (k.x - n.x) / 2,
        y: k.y
      }, {
        x: n.x + (k.x - n.x) / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.leftStart = !0, a.topEnd = !0, w = k.x);
      else f = d(this.chart, j, [{
        x: j.x,
        y: j.y + x / 2
      }, {
        x: j.x + (j.x - n.x) / 2,
        y: j.y + x / 2
      }, {
        x: j.x + (j.x - n.x) / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.bottomStart = !0, a.topEnd = !0, w = j.x + (j.x - n.x) / 2;
      else f = this.leftEnd && t ? d(this.chart, j, [{
        x: j.x,
        y: j.y + x / 2
      }, {
        x: j.x + (j.x - n.x) / 2,
        y: j.y + x / 2
      }, {
        x: j.x + (j.x - n.x) / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b) : d(this.chart, j, [{
        x: j.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.bottomStart = !0, a.topEnd = !0, w = j.x + (j.x - n.x) / 2;
      else f = d(this.chart, i, [{
        x: i.x + x / 2,
        y: i.y
      }, {
        x: i.x + x / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.rightStart = !0, a.topEnd = !0, w = i.x + x / 2;
      else f = d(this.chart, i, [{
        x: i.x + x / 2,
        y: i.y
      }, {
        x: i.x + x / 2,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y - x / 2
      }, {
        x: n.x,
        y: n.y
      }], b), this.rightStart = !0, a.topEnd = !0, w = i.x + x / 2;
      else f = d(this.chart, k, o, b), this.leftStart = !0, a.rightEnd = !0, w = o.x;
      else f = d(this.chart, i, p, b), this.rightStart = !0, a.leftEnd = !0, w = p.x;
      else f = d(this.chart, j, n, b), this.bottomStart = !0, a.topEnd = !0, w = j.x;
      if (f) {
        for (var A = 0, B = this.chart.lines.length; B > A; A++)
          for (var C, D = this.chart.lines[A], E = D.attr("path"), F = f.attr("path"), G = 0, H = E.length - 1; H > G; G++) {
            var I = [];
            I.push(["M", E[G][1], E[G][2]]), I.push(["L", E[G + 1][1], E[G + 1][2]]);
            for (var J = I[0][1], K = I[0][2], L = I[1][1], M = I[1][2], N = 0, O = F.length - 1; O > N; N++) {
              var P = [];
              P.push(["M", F[N][1], F[N][2]]), P.push(["L", F[N + 1][1], F[N + 1][2]]);
              var Q = P[0][1],
                R = P[0][2],
                S = P[1][1],
                T = P[1][2],
                U = e(J, K, L, M, Q, R, S, T);
              if (U.onLine1 && U.onLine2) {
                var V;
                R === T ? Q > S ? (V = ["L", U.x + 2 * y, R], F.splice(N + 1, 0, V), V = ["C", U.x + 2 * y, R, U.x, R - 4 * y, U.x - 2 * y, R], F.splice(N + 2, 0, V), f.attr("path", F)) : (V = ["L", U.x - 2 * y, R], F.splice(N + 1, 0, V), V = ["C", U.x - 2 * y, R, U.x, R - 4 * y, U.x + 2 * y, R], F.splice(N + 2, 0, V), f.attr("path", F)) : R > T ? (V = ["L", Q, U.y + 2 * y], F.splice(N + 1, 0, V), V = ["C", Q, U.y + 2 * y, Q + 4 * y, U.y, Q, U.y - 2 * y], F.splice(N + 2, 0, V), f.attr("path", F)) : (V = ["L", Q, U.y - 2 * y], F.splice(N + 1, 0, V), V = ["C", Q, U.y - 2 * y, Q + 4 * y, U.y, Q, U.y + 2 * y], F.splice(N + 2, 0, V), f.attr("path", F)), N += 2, C += 2
              }
            }
          }
        this.chart.lines.push(f)
      }(!this.chart.maxXFromLine || this.chart.maxXFromLine && w > this.chart.maxXFromLine) && (this.chart.maxXFromLine = w)
    }, r.inherits(h, g), r.inherits(i, g), r.inherits(j, g), r.inherits(k, g), r.inherits(l, g), l.prototype.getLeft = function() {
      var a = this.getY() + this.group.getBBox().height / 2,
        b = this.getX() + this.textMargin;
      return {
        x: b,
        y: a
      }
    }, l.prototype.getRight = function() {
      var a = this.getY() + this.group.getBBox().height / 2,
        b = this.getX() + this.group.getBBox().width - this.textMargin;
      return {
        x: b,
        y: a
      }
    }, r.inherits(m, g), m.prototype.render = function() {
      this.yes_direction && (this[this.yes_direction + "_symbol"] = this.yes_symbol), this.no_direction && (this[this.no_direction + "_symbol"] = this.no_symbol);
      var a = this.getAttr("line-length");
      if (this.bottom_symbol) {
        var b = this.getBottom();
        this.bottom_symbol.getTop(), this.bottom_symbol.isPositioned || (this.bottom_symbol.shiftY(this.getY() + this.height + a), this.bottom_symbol.setX(b.x - this.bottom_symbol.width / 2), this.bottom_symbol.isPositioned = !0, this.bottom_symbol.render())
      }
      if (this.right_symbol) {
        var c = this.getRight();
        if (this.right_symbol.getLeft(), !this.right_symbol.isPositioned) {
          this.right_symbol.setY(c.y - this.right_symbol.height / 2), this.right_symbol.shiftX(this.group.getBBox().x + this.width + a);
          var d = this;
          ! function e() {
            for (var b, c = !1, f = 0, g = d.chart.symbols.length; g > f; f++) {
              b = d.chart.symbols[f];
              var h = Math.abs(b.getCenter().x - d.right_symbol.getCenter().x);
              if (b.getCenter().y > d.right_symbol.getCenter().y && h <= d.right_symbol.width / 2) {
                c = !0;
                break
              }
            }
            c && (d.right_symbol.setX(b.getX() + b.width + a), e())
          }(), this.right_symbol.isPositioned = !0, this.right_symbol.render()
        }
      }
    }, m.prototype.renderLines = function() {
      this.yes_symbol && this.drawLineTo(this.yes_symbol, this.getAttr("yes-text"), this.yes_direction), this.no_symbol && this.drawLineTo(this.no_symbol, this.getAttr("no-text"), this.no_direction)
    }, p.parse = n
  }(); < /script> < script type = "text/javascript" >
  (function(win, doc) {
    function onReady(fn) {
      if (doc.addEventListener) {
        doc.addEventListener('DOMContentLoaded', fn);
      } else {
        doc.attachEvent('onreadystatechange', function() {
          if (doc.readyState === 'interactive')
            fn();
        });
      }
    }

    win.convertUML = function(className, converter, settings) {
      var charts = doc.querySelectorAll("pre." + className),
        arr = [],
        i, j, maxItem, diagaram, text, curNode;

      // Is there a settings object?
      if (settings === void 0) {
        settings = {};
      }

      // Make sure we are dealing with an array
      for (i = 0, maxItem = charts.length; i < maxItem; i++) arr.push(charts[i])

      // Find the UML source element and get the text
      for (i = 0, maxItem = arr.length; i < maxItem; i++) {
        childEl = arr[i].firstChild;
        parentEl = childEl.parentNode;
        text = "";
        for (j = 0; j < childEl.childNodes.length; j++) {
          curNode = childEl.childNodes[j];
          whitespace = /^\s*$/;
          if (curNode.nodeName === "#text" && !(whitespace.test(curNode.nodeValue))) {
            text = curNode.nodeValue;
            break;
          }
        }

        // Do UML conversion and replace source
        el = doc.createElement('div');
        el.className = className;
        parentEl.parentNode.insertBefore(el, parentEl);
        parentEl.parentNode.removeChild(parentEl);
        diagram = converter.parse(text);
        diagram.drawSVG(el, settings);
      }
    }

    onReady(function() {
      convertUML('uml-flowchart', flowchart);
    });
    onReady(function() {
      convertUML('uml-sequence-diagram', Diagram, {
        theme: 'simple'
      });
    });
  })(window, document) < /script>
