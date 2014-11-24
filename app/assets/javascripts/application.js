// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function md5(string) {
  var t1,t2;
  var r1 = [7, 12, 17, 22];
  var r2 = [5, 9, 14, 20];
  var r3 = [4, 11, 16, 23];
  var r4 = [6, 10, 15, 21];
  var r = [].concat(r1, r1, r1, r1, r2, r2, r2, r2, r3, r3, r3, r3, r4, r4, r4, r4);
  var k = new Array(64);
  for(t1 = 0; t1 < k.length; t1++)
    k[t1] = Math.floor(Math.abs(Math.sin(t1 + 1)) * 0x100000000);
  var h = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476];
  var d = [];
  for(t1 = 0; t1 < string.length; t1++)
    d.push(string.charCodeAt(t1) & 0xFF);
  var b = d.length * 8;
  d.push(0x80);
  var e = new Array((120 - d.length % 64) % 64);
  for(t1 = 0; t1 < e.length; t1++)
    e[t1] = 0;
  d = d.concat(e);
  for(t1 = 0; t1 < 8; t1++) {
    d.push(b & 0xFF);
    b = b >>> 8;
  }
  e = new Array(d.length / 4);
  for(t1 = 0; t1 < e.length; t1++) {
    e[t1] = 0;
    for(t2 = 0; t2 < 4; t2++)
      e[t1] += d[t1 * 4 + t2] << (t2 * 8);
  }
  var f, g, u;
  for(t1 = 0; t1 < e.length; t1 += 16) {
    var w = h.slice();
    for(t2 = 0; t2 < 64; t2++) {
      if(t2 < 16) {
        f = w[1] & w[2] | ~w[1] & w[3];
        g = t2;
      } else if(t2 < 32) {
        f = w[1] & w[3] | w[2] & ~w[3];
        g = (t2 * 5 + 1) % 16;
      } else if(t2 < 48) {
        f = w[1] ^ w[2] ^ w[3];
        g = (t2 * 3 + 5) % 16;
      } else {
        f = (w[1] | ~w[3]) ^ w[2];
        g = (t2 * 7) % 16;
      }
      u = (w[0] + f + k[t2] + e[t1 + g]) & 0xFFFFFFFF;
      w[0] = ((u << r[t2] | u >>> (32 - r[t2])) + w[1]) & 0xFFFFFFFF;
      w.unshift(w.pop());
    }
    for(t2 = 0; t2 < w.length; t2++)
      h[t2] += w[t2];
  }
  d = "";
  for(t1 = 0; t1 < h.length; t1++) {
    for(t2 = 0; t2 < 4; t2++) {
      e = ((h[t1] >>> (t2 * 8)) & 0xFF).toString(16);
      d += e.length == 2 ? e : "0" + e;
    }
  }
  return d;
}
