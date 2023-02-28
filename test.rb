# test.rb
# Copyright (C) 2003-2006  K.Kosako (sndgk393 AT ybb DOT ne DOT jp)

$SILENT = false
if (ARGV.size > 0 and ARGV[0] == '-s')
  $SILENT = true
end

def pr(result, reg, str, n = 0, *range)
  printf("%s /%s/:'%s'", result, reg.source, str)
  if (n.class == Fixnum)
    printf(":%d", n) if n != 0
    if (range.size > 0)
      if (range[3].nil?)
	printf(" (%d-%d : X-X)", range[0], range[1])
      else
	printf(" (%d-%d : %d-%d)", range[0], range[1], range[2], range[3])
      end
    end
  else
    printf("  %s", n)
  end
  printf("\n")
end

def rok(result_opt, reg, str, n = 0, *range)
  result = "OK" + result_opt
  result += " " * (7 - result.length)
  pr(result, reg, str, n, *range) unless $SILENT
  $rok += 1
end

def rfail(result_opt, reg, str, n = 0, *range)
  result = "FAIL" + result_opt
  result += " " * (7 - result.length)
  pr(result, reg, str, n, *range)
  $rfail += 1
end

def x(reg, str, s, e, n = 0)
  m = reg.match(str)
  if m
    if (m.size() <= n)
      rfail("(%d)" % (m.size()-1), reg, str, n)
    else
      if (m.begin(n) == s && m.end(n) == e)
	rok("", reg, str, n)
      else
	rfail("", reg, str, n, s, e, m.begin(n), m.end(n))
      end
    end
  else
    rfail("", reg, str, n)
  end
end

def n(reg, str)
  m = reg.match(str)
  if m
    rfail("(N)", reg, str, 0)
  else
    rok("(N)", reg, str, 0)
  end
end

def r(reg, str, index, pos = nil)
  if (pos)
    res = str.rindex(reg, pos)
  else
    res = str.rindex(reg)
  end
  if res
    if (res == index)
      rok("(r)", reg, str)
    else
      rfail("(r)", reg, str, [res, '-', index])
    end
  else
    rfail("(r)", reg, str)
  end
end

def i(reg, str, s = 0, e = 0, n = 0)
  # ignore
end

### main ###
$rok = $rfail = 0


x(/\M-Z/n, "\xDA", 0, 1)

# from URI::ABS_URI
n(/^
        ([a-zA-Z][-+.a-zA-Z\d]*):                     (?# 1: scheme)
        (?:
           ((?:[-_.!~*'()a-zA-Z\d;?:@&=+$,]|%[a-fA-F\d]{2})(?:[-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]|%[a-fA-F\d]{2})*)              (?# 2: opaque)
        |
           (?:(?:
             \/\/(?:
                 (?:(?:((?:[-_.!~*'()a-zA-Z\d;:&=+$,]|%[a-fA-F\d]{2})*)@)?  (?# 3: userinfo)
                   (?:((?:(?:(?:[a-zA-Z\d](?:[-a-zA-Z\d]*[a-zA-Z\d])?)\.)*(?:[a-zA-Z](?:[-a-zA-Z\d]*[a-zA-Z\d])?)\.?|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|\[(?:(?:[a-fA-F\d]{1,4}:)*(?:[a-fA-F\d]{1,4}|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|(?:(?:[a-fA-F\d]{1,4}:)*[a-fA-F\d]{1,4})?::(?:(?:[a-fA-F\d]{1,4}:)*(?:[a-fA-F\d]{1,4}|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}))?)\]))(?::(\d*))?))?(?# 4: host, 5: port)
               |
                 ((?:[-_.!~*'()a-zA-Z\d$,;+@&=+]|%[a-fA-F\d]{2})+)           (?# 6: registry)
               )
             |
             (?!\/\/))                              (?# XXX: '\/\/' is the mark for hostport)
             (\/(?:[-_.!~*'()a-zA-Z\d:@&=+$,]|%[a-fA-F\d]{2})*(?:;(?:[-_.!~*'()a-zA-Z\d:@&=+$,]|%[a-fA-F\d]{2})*)*(?:\/(?:[-_.!~*'()a-zA-Z\d:@&=+$,]|%[a-fA-F\d]{2})*(?:;(?:[-_.!~*'()a-zA-Z\d:@&=+$,]|%[a-fA-F\d]{2})*)*)*)?              (?# 7: path)
           )(?:\?((?:[-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]|%[a-fA-F\d]{2})*))?           (?# 8: query)
        )
        (?:\#((?:[-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]]|%[a-fA-F\d]{2})*))?            (?# 9: fragment)
      $/xn, "http://example.org/Andr\xC3\xA9")


def test_sb(enc)
$KCODE = enc

x(//, '', 0, 0)
x(/^/, '', 0, 0)
x(/$/, '', 0, 0)
x(/\G/, '', 0, 0)
x(/\A/, '', 0, 0)
x(/\Z/, '', 0, 0)
x(/\z/, '', 0, 0)
x(/^$/, '', 0, 0)
x(/\ca/, "\001", 0, 1)
x(/\C-b/, "\002", 0, 1)
x(/\c\\/, "\034", 0, 1)
x(/q[\c\\]/, "q\034", 0, 2)
x(//, 'a', 0, 0)
x(/a/, 'a', 0, 1)
x(/\x61/, 'a', 0, 1)
x(/aa/, 'aa', 0, 2)
x(/aaa/, 'aaa', 0, 3)
x(/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 0, 35)
x(/ab/, 'ab', 0, 2)
x(/b/, 'ab', 1, 2)
x(/bc/, 'abc', 1, 3)
x(/(?i:#RET#)/, '#INS##RET#', 5, 10)
x(/\17/, "\017", 0, 1)
x(/\x1f/, "\x1f", 0, 1)
x(/a(?#....\\JJJJ)b/, 'ab', 0, 2)
x(Regexp.new("(?x)\ta .\n+b"), '0a123b4', 1, 6)
x(/(?x)  G (o O(?-x)oO) g L/, "GoOoOgLe", 0, 7)
x(/./, 'a', 0, 1)
n(/./, '')
x(/../, 'ab', 0, 2)
x(/\w/, 'e', 0, 1)
n(/\W/, 'e')
x(/\s/, ' ', 0, 1)
x(/\S/, 'b', 0, 1)
x(/\d/, '4', 0, 1)
n(/\D/, '4')
x(/\b/, 'z ', 0, 0)
x(/\b/, ' z', 1, 1)
x(/\B/, 'zz ', 1, 1)
x(/\B/, 'z ', 2, 2)
x(/\B/, ' z', 0, 0)
x(/[ab]/, 'b', 0, 1)
n(/[ab]/, 'c')
x(/[a-z]/, 't', 0, 1)
n(/[^a]/, 'a')
x(/[^a]/, "\n", 0, 1)
x(/[]]/, ']', 0, 1)
n(/[^]]/, ']')
x(/[\^]+/, '0^^1', 1, 3)
x(/[b-]/, 'b', 0, 1)
x(/[b-]/, '-', 0, 1)
x(/[\w]/, 'z', 0, 1)
n(/[\w]/, ' ')
x(/[\W]/, 'b$', 1, 2)
x(/[\d]/, '5', 0, 1)
n(/[\d]/, 'e')
x(/[\D]/, 't', 0, 1)
n(/[\D]/, '3')
x(/[\s]/, ' ', 0, 1)
n(/[\s]/, 'a')
x(/[\S]/, 'b', 0, 1)
n(/[\S]/, ' ')
x(/[\w\d]/, '2', 0, 1)
n(/[\w\d]/, ' ')
x(/[[:upper:]]/, 'B', 0, 1)
x(/[*[:xdigit:]+]/, '+', 0, 1)
x(/[*[:xdigit:]+]/, 'GHIKK-9+*', 6, 7)
x(/[*[:xdigit:]+]/, '-@^+', 3, 4)
n(/[[:upper]]/, 'A')
x(/[[:upper]]/, ':', 0, 1)
x(/[\044-\047]/, "\046", 0, 1)
x(/[\x5a-\x5c]/, "\x5b", 0, 1)
x(/[\x6A-\x6D]/, "\x6c", 0, 1)
n(/[\x6A-\x6D]/, "\x6E")
n(/^[0-9A-F]+ 0+ UNDEF /, '75F 00000000 SECT14A notype ()    External    | _rb_apply')
x(/[\[]/, '[', 0, 1)
x(/[\]]/, ']', 0, 1)
x(/[&]/, '&', 0, 1)
x(/[[ab]]/, 'b', 0, 1)
x(/[[ab]c]/, 'c', 0, 1)
n(/[[^a]]/, 'a')
n(/[^[a]]/, 'a')
x(/[[ab]&&bc]/, 'b', 0, 1)
n(/[[ab]&&bc]/, 'a')
n(/[[ab]&&bc]/, 'c')
x(/[a-z&&b-y&&c-x]/, 'w', 0, 1)
n(/[^a-z&&b-y&&c-x]/, 'w')
x(/[[^a&&a]&&a-z]/, 'b', 0, 1)
n(/[[^a&&a]&&a-z]/, 'a')
x(/[[^a-z&&bcdef]&&[^c-g]]/, 'h', 0, 1)
n(/[[^a-z&&bcdef]&&[^c-g]]/, 'c')
x(/[^[^abc]&&[^cde]]/, 'c', 0, 1)
x(/[^[^abc]&&[^cde]]/, 'e', 0, 1)
n(/[^[^abc]&&[^cde]]/, 'f')
x(/[a-&&-a]/, '-', 0, 1)
n(/[a\-&&\-a]/, '&')
n(/\wabc/, ' abc')
x(/a\Wbc/, 'a bc', 0, 4)
x(/a.b.c/, 'aabbc', 0, 5)
x(/.\wb\W..c/, 'abb bcc', 0, 7)
x(/\s\wzzz/, ' zzzz', 0, 5)
x(/aa.b/, 'aabb', 0, 4)
n(/.a/, 'ab')
x(/.a/, 'aa', 0, 2)
x(/^a/, 'a', 0, 1)
x(/^a$/, 'a', 0, 1)
x(/^\w$/, 'a', 0, 1)
n(/^\w$/, ' ')
x(/^\wab$/, 'zab', 0, 3)
x(/^\wabcdef$/, 'zabcdef', 0, 7)
x(/^\w...def$/, 'zabcdef', 0, 7)
x(/\w\w\s\Waaa\d/, 'aa  aaa4', 0, 8)
x(/\A\Z/, '', 0, 0)
x(/\Axyz/, 'xyz', 0, 3)
x(/xyz\Z/, 'xyz', 0, 3)
x(/xyz\z/, 'xyz', 0, 3)
x(/a\Z/, 'a', 0, 1)
x(/\Gaz/, 'az', 0, 2)
n(/\Gz/, 'bza')
n(/az\G/, 'az')
n(/az\A/, 'az')
n(/a\Az/, 'az')
x(/\^\$/, '^$', 0, 2)
x(/^x?y/, 'xy', 0, 2)
x(/^(x?y)/, 'xy', 0, 2)
x(/\w/, '_', 0, 1)
n(/\W/, '_')
x(/(?=z)z/, 'z', 0, 1)
n(/(?=z)./, 'a')
x(/(?!z)a/, 'a', 0, 1)
n(/(?!z)a/, 'z')
x(/(?i:a)/, 'a', 0, 1)
x(/(?i:a)/, 'A', 0, 1)
x(/(?i:A)/, 'a', 0, 1)
n(/(?i:A)/, 'b')
x(/(?i:[A-Z])/, 'a', 0, 1)
x(/(?i:[f-m])/, 'H', 0, 1)
x(/(?i:[f-m])/, 'h', 0, 1)
n(/(?i:[f-m])/, 'e')
x(/(?i:[A-c])/, 'D', 0, 1)
#n(/(?i:[a-C])/, 'D')   # changed spec.(error) 2003/09/17
#n(/(?i:[b-C])/, 'A')
#x(/(?i:[a-C])/, 'B', 0, 1)
#n(/(?i:[c-X])/, '[')
n(/(?i:[^a-z])/, 'A')
n(/(?i:[^a-z])/, 'a')
x(/(?i:[!-k])/, 'Z', 0, 1)
x(/(?i:[!-k])/, '7', 0, 1)
x(/(?i:[T-}])/, 'b', 0, 1)
x(/(?i:[T-}])/, '{', 0, 1)
x(/(?i:\?a)/, '?A', 0, 2)
x(/(?i:\*A)/, '*a', 0, 2)
n(/./, "\n")
x(/(?m:.)/, "\n", 0, 1)
x(/(?m:a.)/, "a\n", 0, 2)
x(/(?m:.b)/, "a\nb", 1, 3)
x(/.*abc/, "dddabdd\nddabc", 8, 13)
x(/(?m:.*abc)/, "dddabddabc", 0, 10)
n(/(?i)(?-i)a/, "A")
n(/(?i)(?-i:a)/, "A")
x(/a?/, '', 0, 0)
x(/a?/, 'b', 0, 0)
x(/a?/, 'a', 0, 1)
x(/a*/, '', 0, 0)
x(/a*/, 'a', 0, 1)
x(/a*/, 'aaa', 0, 3)
x(/a*/, 'baaaa', 0, 0)
n(/a+/, '')
x(/a+/, 'a', 0, 1)
x(/a+/, 'aaaa', 0, 4)
x(/a+/, 'aabbb', 0, 2)
x(/a+/, 'baaaa', 1, 5)
x(/.?/, '', 0, 0)
x(/.?/, 'f', 0, 1)
x(/.?/, "\n", 0, 0)
x(/.*/, '', 0, 0)
x(/.*/, 'abcde', 0, 5)
x(/.+/, 'z', 0, 1)
x(/.+/, "zdswer\n", 0, 6)
x(/(.*)a\1f/, "babfbac", 0, 4)
x(/(.*)a\1f/, "bacbabf", 3, 7)
x(/((.*)a\2f)/, "bacbabf", 3, 7)
x(/(.*)a\1f/, "baczzzzzz\nbazz\nzzzzbabf", 19, 23)
x(/a|b/, 'a', 0, 1)
x(/a|b/, 'b', 0, 1)
x(/|a/, 'a', 0, 0)
x(/(|a)/, 'a', 0, 0)
x(/ab|bc/, 'ab', 0, 2)
x(/ab|bc/, 'bc', 0, 2)
x(/z(?:ab|bc)/, 'zbc', 0, 3)
x(/a(?:ab|bc)c/, 'aabc', 0, 4)
x(/ab|(?:ac|az)/, 'az', 0, 2)
x(/a|b|c/, 'dc', 1, 2)
x(/a|b|cd|efg|h|ijk|lmn|o|pq|rstuvwx|yz/, 'pqr', 0, 2)
n(/a|b|cd|efg|h|ijk|lmn|o|pq|rstuvwx|yz/, 'mn')
x(/a|^z/, 'ba', 1, 2)
x(/a|^z/, 'za', 0, 1)
x(/a|\Gz/, 'bza', 2, 3)
x(/a|\Gz/, 'za', 0, 1)
x(/a|\Az/, 'bza', 2, 3)
x(/a|\Az/, 'za', 0, 1)
x(/a|b\Z/, 'ba', 1, 2)
x(/a|b\Z/, 'b', 0, 1)
x(/a|b\z/, 'ba', 1, 2)
x(/a|b\z/, 'b', 0, 1)
x(/\w|\s/, ' ', 0, 1)
n(/\w|\w/, ' ')
x(/\w|%/, '%', 0, 1)
x(/\w|[&$]/, '&', 0, 1)
x(/[b-d]|[^e-z]/, 'a', 0, 1)
x(/(?:a|[c-f])|bz/, 'dz', 0, 1)
x(/(?:a|[c-f])|bz/, 'bz', 0, 2)
x(/abc|(?=zz)..f/, 'zzf', 0, 3)
x(/abc|(?!zz)..f/, 'abf', 0, 3)
x(/(?=za)..a|(?=zz)..a/, 'zza', 0, 3)
n(/(?>a|abd)c/, 'abdc')
x(/(?>abd|a)c/, 'abdc', 0, 4)
x(/a?|b/, 'a', 0, 1)
x(/a?|b/, 'b', 0, 0)
x(/a?|b/, '', 0, 0)
x(/a*|b/, 'aa', 0, 2)
x(/a*|b*/, 'ba', 0, 0)
x(/a*|b*/, 'ab', 0, 1)
x(/a+|b*/, '', 0, 0)
x(/a+|b*/, 'bbb', 0, 3)
x(/a+|b*/, 'abbb', 0, 1)
n(/a+|b+/, '')
x(/(a|b)?/, 'b', 0, 1)
x(/(a|b)*/, 'ba', 0, 2)
x(/(a|b)+/, 'bab', 0, 3)
x(/(ab|ca)+/, 'caabbc', 0, 4)
x(/(ab|ca)+/, 'aabca', 1, 5)
x(/(ab|ca)+/, 'abzca', 0, 2)
x(/(a|bab)+/, 'ababa', 0, 5)
x(/(a|bab)+/, 'ba', 1, 2)
x(/(a|bab)+/, 'baaaba', 1, 4)
x(/(?:a|b)(?:a|b)/, 'ab', 0, 2)
x(/(?:a*|b*)(?:a*|b*)/, 'aaabbb', 0, 3)
x(/(?:a*|b*)(?:a+|b+)/, 'aaabbb', 0, 6)
x(/(?:a+|b+){2}/, 'aaabbb', 0, 6)
x(/h{0,}/, 'hhhh', 0, 4)
x(/(?:a+|b+){1,2}/, 'aaabbb', 0, 6)
n(/ax{2}*a/, '0axxxa1')
n(/a.{0,2}a/, "0aXXXa0")
n(/a.{0,2}?a/, "0aXXXa0")
n(/a.{0,2}?a/, "0aXXXXa0")
x(/^a{2,}?a$/, "aaa", 0, 3)
x(/^[a-z]{2,}?$/, "aaa", 0, 3)
x(/(?:a+|\Ab*)cc/, 'cc', 0, 2)
n(/(?:a+|\Ab*)cc/, 'abcc')
x(/(?:^a+|b+)*c/, 'aabbbabc', 6, 8)
x(/(?:^a+|b+)*c/, 'aabbbbc', 0, 7)
x(/a|(?i)c/, 'C', 0, 1)
x(/(?i)c|a/, 'C', 0, 1)
i(/(?i)c|a/, 'A', 0, 1)  # different spec.
x(/(?i:c)|a/, 'C', 0, 1)
n(/(?i:c)|a/, 'A')
x(/[abc]?/, 'abc', 0, 1)
x(/[abc]*/, 'abc', 0, 3)
x(/[^abc]*/, 'abc', 0, 0)
n(/[^abc]+/, 'abc')
x(/a??/, 'aaa', 0, 0)
x(/ba??b/, 'bab', 0, 3)
x(/a*?/, 'aaa', 0, 0)
x(/ba*?/, 'baa', 0, 1)
x(/ba*?b/, 'baab', 0, 4)
x(/a+?/, 'aaa', 0, 1)
x(/ba+?/, 'baa', 0, 2)
x(/ba+?b/, 'baab', 0, 4)
x(/(?:a?)??/, 'a', 0, 0)
x(/(?:a??)?/, 'a', 0, 0)
x(/(?:a?)+?/, 'aaa', 0, 1)
x(/(?:a+)??/, 'aaa', 0, 0)
x(/(?:a+)??b/, 'aaab', 0, 4)
i(/(?:ab)?{2}/, '', 0, 0)   # GNU regex bug
x(/(?:ab)?{2}/, 'ababa', 0, 4)
x(/(?:ab)*{0}/, 'ababa', 0, 0)
x(/(?:ab){3,}/, 'abababab', 0, 8)
n(/(?:ab){3,}/, 'abab')
x(/(?:ab){2,4}/, 'ababab', 0, 6)
x(/(?:ab){2,4}/, 'ababababab', 0, 8)
x(/(?:ab){2,4}?/, 'ababababab', 0, 4)
x(/(?:ab){,}/, 'ab{,}', 0, 5)
x(/(?:abc)+?{2}/, 'abcabcabc', 0, 6)
x(/(?:X*)(?i:xa)/, 'XXXa', 0, 4)
x(/(d+)([^abc]z)/, 'dddz', 0, 4)
x(/([^abc]*)([^abc]z)/, 'dddz', 0, 4)
x(/(\w+)(\wz)/, 'dddz', 0, 4)
x(/(a)/, 'a', 0, 1, 1)
x(/(ab)/, 'ab', 0, 2, 1)
x(/((ab))/, 'ab', 0, 2)
x(/((ab))/, 'ab', 0, 2, 1)
x(/((ab))/, 'ab', 0, 2, 2)
x(/((((((((((((((((((((ab))))))))))))))))))))/, 'ab', 0, 2, 20)
x(/(ab)(cd)/, 'abcd', 0, 2, 1)
x(/(ab)(cd)/, 'abcd', 2, 4, 2)
x(/()(a)bc(def)ghijk/, 'abcdefghijk', 3, 6, 3)
x(/(()(a)bc(def)ghijk)/, 'abcdefghijk', 3, 6, 4)
x(/(^a)/, 'a', 0, 1)
x(/(a)|(a)/, 'ba', 1, 2, 1)
x(/(^a)|(a)/, 'ba', 1, 2, 2)
x(/(a?)/, 'aaa', 0, 1, 1)
x(/(a*)/, 'aaa', 0, 3, 1)
x(/(a*)/, '', 0, 0, 1)
x(/(a+)/, 'aaaaaaa', 0, 7, 1)
x(/(a+|b*)/, 'bbbaa', 0, 3, 1)
x(/(a+|b?)/, 'bbbaa', 0, 1, 1)
x(/(abc)?/, 'abc', 0, 3, 1)
x(/(abc)*/, 'abc', 0, 3, 1)
x(/(abc)+/, 'abc', 0, 3, 1)
x(/(xyz|abc)+/, 'abc', 0, 3, 1)
x(/([xyz][abc]|abc)+/, 'abc', 0, 3, 1)
x(/((?i:abc))/, 'AbC', 0, 3, 1)
x(/(abc)(?i:\1)/, 'abcABC', 0, 6)
x(/((?m:a.c))/, "a\nc", 0, 3, 1)
x(/((?=az)a)/, 'azb', 0, 1, 1)
x(/abc|(.abd)/, 'zabd', 0, 4, 1)
x(/(?:abc)|(ABC)/, 'abc', 0, 3)
x(/(?i:(abc))|(zzz)/, 'ABC', 0, 3, 1)
x(/a*(.)/, 'aaaaz', 4, 5, 1)
x(/a*?(.)/, 'aaaaz', 0, 1, 1)
x(/a*?(c)/, 'aaaac', 4, 5, 1)
x(/[bcd]a*(.)/, 'caaaaz', 5, 6, 1)
x(/(\Abb)cc/, 'bbcc', 0, 2, 1)
n(/(\Abb)cc/, 'zbbcc')
x(/(^bb)cc/, 'bbcc', 0, 2, 1)
n(/(^bb)cc/, 'zbbcc')
x(/cc(bb$)/, 'ccbb', 2, 4, 1)
n(/cc(bb$)/, 'ccbbb')
#n(/\1/, 'a')     # compile error on Oniguruma
n(/(\1)/, '')
n(/\1(a)/, 'aa')
n(/(a(b)\1)\2+/, 'ababb')
n(/(?:(?:\1|z)(a))+$/, 'zaa')
x(/(?:(?:\1|z)(a))+$/, 'zaaa', 0, 4)
x(/(a)(?=\1)/, 'aa', 0, 1)
n(/(a)$|\1/, 'az')
x(/(a)\1/, 'aa', 0, 2)
n(/(a)\1/, 'ab')
x(/(a?)\1/, 'aa', 0, 2)
x(/(a??)\1/, 'aa', 0, 0)
x(/(a*)\1/, 'aaaaa', 0, 4)
x(/(a*)\1/, 'aaaaa', 0, 2, 1)
x(/a(b*)\1/, 'abbbb', 0, 5)
x(/a(b*)\1/, 'ab', 0, 1)
x(/(a*)(b*)\1\2/, 'aaabbaaabb', 0, 10)
x(/(a*)(b*)\2/, 'aaabbbb', 0, 7)
x(/(((((((a*)b))))))c\7/, 'aaabcaaa', 0, 8)
x(/(((((((a*)b))))))c\7/, 'aaabcaaa', 0, 3, 7)
x(/(a)(b)(c)\2\1\3/, 'abcbac', 0, 6)
x(/([a-d])\1/, 'cc', 0, 2)
x(/(\w\d\s)\1/, 'f5 f5 ', 0, 6)
n(/(\w\d\s)\1/, 'f5 f5')
x(/(who|[a-c]{3})\1/, 'whowho', 0, 6)
x(/...(who|[a-c]{3})\1/, 'abcwhowho', 0, 9)
x(/(who|[a-c]{3})\1/, 'cbccbc', 0, 6)
x(/(^a)\1/, 'aa', 0, 2)
n(/(^a)\1/, 'baa')
n(/(a$)\1/, 'aa')
n(/(ab\Z)\1/, 'ab')
x(/(a*\Z)\1/, 'a', 1, 1)
x(/.(a*\Z)\1/, 'ba', 1, 2)
x(/(.(abc)\2)/, 'zabcabc', 0, 7, 1)
x(/(.(..\d.)\2)/, 'z12341234', 0, 9, 1)
x(/((?i:az))\1/, 'AzAz', 0, 4)
n(/((?i:az))\1/, 'Azaz')
x(/(?<=a)b/, 'ab', 1, 2)
n(/(?<=a)b/, 'bb')
x(/(?<=a|b)b/, 'bb', 1, 2)
x(/(?<=a|bc)b/, 'bcb', 2, 3)
x(/(?<=a|bc)b/, 'ab', 1, 2)
x(/(?<=a|bc||defghij|klmnopq|r)z/, 'rz', 1, 2)
x(/(a)\g<1>/, 'aa', 0, 2)
x(/(?<!a)b/, 'cb', 1, 2)
n(/(?<!a)b/, 'ab')
x(/(?<!a|bc)b/, 'bbb', 0, 1)
n(/(?<!a|bc)z/, 'bcz')
x(/(?<name1>a)/, 'a', 0, 1)
x(/(?<name_2>ab)\g<name_2>/, 'abab', 0, 4)
x(/(?<name_3>.zv.)\k<name_3>/, 'azvbazvb', 0, 8)
x(/(?<=\g<ab>)|-\zEND (?<ab>XyZ)/, 'XyZ', 3, 3)
x(/(?<n>|a\g<n>)+/, '', 0, 0)
x(/(?<n>|\(\g<n>\))+$/, '()(())', 0, 6)
x(/\g<n>(?<n>.){0}/, 'X', 0, 1, 1)
x(/\g<n>(abc|df(?<n>.YZ){2,8}){0}/, 'XYZ', 0, 3)
x(/\A(?<n>(a\g<n>)|)\z/, 'aaaa', 0, 4)
x(/(?<n>|\g<m>\g<n>)\z|\zEND (?<m>a|(b)\g<m>)/, 'bbbbabba', 0, 8)
x(/(?<name1240>\w+\sx)a+\k<name1240>/, '  fg xaaaaaaaafg x', 2, 18)
x(/(z)()()(?<_9>a)\g<_9>/, 'zaa', 2, 3, 1)
x(/(.)(((?<_>a)))\k<_>/, 'zaa', 0, 3)
x(/((?<name1>\d)|(?<name2>\w))(\k<name1>|\k<name2>)/, 'ff', 0, 2)
x(/(?:(?<x>)|(?<x>efg))\k<x>/, '', 0, 0)
x(/(?:(?<x>abc)|(?<x>efg))\k<x>/, 'abcefgefg', 3, 9)
n(/(?:(?<x>abc)|(?<x>efg))\k<x>/, 'abcefg')
x(/(?:(?<n1>.)|(?<n1>..)|(?<n1>...)|(?<n1>....)|(?<n1>.....)|(?<n1>......)|(?<n1>.......)|(?<n1>........)|(?<n1>.........)|(?<n1>..........)|(?<n1>...........)|(?<n1>............)|(?<n1>.............)|(?<n1>..............))\k<n1>$/, 'a-pyumpyum', 2, 10)
x(/(?:(?<n1>.)|(?<n1>..)|(?<n1>...)|(?<n1>....)|(?<n1>.....)|(?<n1>......)|(?<n1>.......)|(?<n1>........)|(?<n1>.........)|(?<n1>..........)|(?<n1>...........)|(?<n1>............)|(?<n1>.............)|(?<n1>..............))\k<n1>$/, 'xxxxabcdefghijklmnabcdefghijklmn', 4, 18, 14)
x(/(?<name1>)(?<name2>)(?<name3>)(?<name4>)(?<name5>)(?<name6>)(?<name7>)(?<name8>)(?<name9>)(?<name10>)(?<name11>)(?<name12>)(?<name13>)(?<name14>)(?<name15>)(?<name16>aaa)(?<name17>)$/, 'aaa', 0, 3, 16)
x(/(?<foo>a|\(\g<foo>\))/, 'a', 0, 1)
x(/(?<foo>a|\(\g<foo>\))/, '((((((a))))))', 0, 13)
x(/(?<foo>a|\(\g<foo>\))/, '((((((((a))))))))', 0, 17, 1)
x(/\g<bar>|\zEND(?<bar>.*abc$)/, 'abcxxxabc', 0, 9)
x(/\g<1>|\zEND(.a.)/, 'bac', 0, 3)
x(/\g<_A>\g<_A>|\zEND(.a.)(?<_A>.b.)/, 'xbxyby', 3, 6, 1)
x(/\A(?:\g<pon>|\g<pan>|\zEND  (?<pan>a|c\g<pon>c)(?<pon>b|d\g<pan>d))$/, 'cdcbcdc', 0, 7)
x(/\A(?<n>|a\g<m>)\z|\zEND (?<m>\g<n>)/, 'aaaa', 0, 4)
x(/(?<n>(a|b\g<n>c){3,5})/, 'baaaaca', 1, 5)
x(/(?<n>(a|b\g<n>c){3,5})/, 'baaaacaaaaa', 0, 10)
x(/(?<pare>\(([^\(\)]++|\g<pare>)*+\))/, '((a))', 0, 5)
x(/()*\1/, '', 0, 0)
x(/(?:()|())*\1\2/, '', 0, 0)
x(/(?:\1a|())*/, 'a', 0, 0, 1)
x(/x((.)*)*x/, '0x1x2x3', 1, 6)
x(/x((.)*)*x(?i:\1)\Z/, '0x1x2x1X2', 1, 9)
x(/(?:()|()|()|()|()|())*\2\5/, '', 0, 0)
x(/(?:()|()|()|(x)|()|())*\2b\5/, 'b', 0, 1)

r(//, '', 0)
r(/a/, 'a', 0)
r(/a/, 'a', 0, 1)
r(/b/, 'abc', 1)
r(/b/, 'abc', 1, 2)
r(/./, 'a', 0)
r(/.*/, 'abcde fgh', 9)
r(/a*/, 'aaabbc', 6)
r(/a+/, 'aaabbc', 2)
r(/a?/, 'bac', 3)
r(/a??/, 'bac', 3)
r(/abcde/, 'abcdeavcd', 0)
r(/\w\d\s/, '  a2 aa $3 ', 2)
r(/[c-f]aa[x-z]/, '3caaycaaa', 1)
r(/(?i:fG)g/, 'fGgFggFgG', 3)
r(/a|b/, 'b', 0)
r(/ab|bc|cd/, 'bcc', 0)
r(/(ffy)\1/, 'ffyffyffy', 3)
r(/|z/, 'z', 1)
r(/^az/, 'azaz', 0)
r(/az$/, 'azaz', 2)
r(/(((.a)))\3/, 'zazaaa', 0)
r(/(ac*?z)\1/, 'aacczacczacz', 1)
r(/aaz{3,4}/, 'bbaabbaazzzaazz', 6)
r(/\000a/, "b\000a", 1)
r(/ff\xfe/, "fff\xfe", 1)
r(/...abcdefghijklmnopqrstuvwxyz/, 'zzzzzabcdefghijklmnopqrstuvwxyz', 2)
end

def test_euc(enc)
$KCODE = enc

x(/\xED\xF2/, "\xed\xf2", 0, 2)
x(//, '��', 0, 0)
x(/��/, '��', 0, 2)
n(/��/, '��')
x(/����/, '����', 0, 4)
x(/������/, '������', 0, 6)
x(/����������������������������������������������������������������������/, '����������������������������������������������������������������������', 0, 70)
x(/��/, '����', 2, 4)
x(/����/, '������', 2, 6)
x(/\xca\xb8/, "\xca\xb8", 0, 2)
x(/./, '��', 0, 2)
x(/../, '����', 0, 4)
x(/(?u)\w/, '��', 0, 2)
n(/(?u)\W/, '��')
x(/(?u)[\W]/, '��$', 2, 3)
x(/\S/, '��', 0, 2)
x(/\S/, '��', 0, 2)
x(/\b/, '�� ', 0, 0)
x(/\b/, ' ��', 1, 1)
x(/\B/, '���� ', 2, 2)
x(/\B/, '�� ', 3, 3)
x(/\B/, ' ��', 0, 0)
x(/[����]/, '��', 0, 2)
n(/[�ʤ�]/, '��')
x(/[��-��]/, '��', 0, 2)
n(/[^��]/, '��')
x(/(?u)[\w]/, '��', 0, 2)
n(/[\d]/, '��')
x(/[\D]/, '��', 0, 2)
n(/[\s]/, '��')
x(/[\S]/, '��', 0, 2)
x(/(?u)[\w\d]/, '��', 0, 2)
x(/(?u)[\w\d]/, '   ��', 3, 5)
#x(/[\xa4\xcf-\xa4\xd3]/, "\xa4\xd0", 0, 2)  # diff spec with GNU regex.
#n(/[\xb6\xe7-\xb6\xef]/, "\xb6\xe5")        # diff spec with GNU regex.
n(/(?u)\w����/, ' ����')
x(/(?u)��\W��/, '�� ��', 0, 5)
x(/��.��.��/, '����������', 0, 10)
x(/(?u).\w��\W..��/, '������ ������', 0, 13)
x(/(?u)\s\w������/, ' ��������', 0, 9)
x(/����.��/, '��������', 0, 8)
n(/.��/, '����')
x(/.��/, '����', 0, 4)
x(/^��/, '��', 0, 2)
x(/^��$/, '��', 0, 2)
x(/(?u)^\w$/, '��', 0, 2)
x(/(?u)^\w����������$/, 'z����������', 0, 11)
x(/(?u)^\w...������$/, 'z������������', 0, 13)
x(/(?u)\w\w\s\W������\d/, 'a��  ������4', 0, 12)
x(/\A������/, '������', 0, 6)
x(/����\Z/, '����', 0, 6)
x(/������\z/, '������', 0, 6)
x(/������\Z/, "������\n", 0, 6)
x(/\G�ݤ�/, '�ݤ�', 0, 4)
n(/\G��/, '������')
n(/�Ȥ�\G/, '�Ȥ�')
n(/�ޤ�\A/, '�ޤ�')
n(/��\A��/, '�ޤ�')
x(/(?=��)��/, '��', 0, 2)
n(/(?=��)./, '��')
x(/(?!��)��/, '��', 0, 2)
n(/(?!��)��/, '��')
x(/(?i:��)/, '��', 0, 2)
x(/(?i:�֤�)/, '�֤�', 0, 4)
n(/(?i:��)/, '��')
x(/(?m:��.)/, "��\n", 0, 3)
x(/(?m:.��)/, "��\n��", 2, 5)
x(/��?/, '', 0, 0)
x(/��?/, '��', 0, 0)
x(/��?/, '��', 0, 2)
x(/��*/, '', 0, 0)
x(/��*/, '��', 0, 2)
x(/��*/, '�һһ�', 0, 6)
x(/��*/, '����������', 0, 0)
n(/��+/, '')
x(/��+/, '��', 0, 2)
x(/��+/, '��������', 0, 8)
x(/��+/, '����������', 0, 4)
x(/��+/, '����������', 2, 10)
x(/.?/, '��', 0, 2)
x(/.*/, '�ѤԤפ�', 0, 8)
x(/.+/, '��', 0, 2)
x(/.+/, "��������\n", 0, 8)
x(/��|��/, '��', 0, 2)
x(/��|��/, '��', 0, 2)
x(/����|����/, '����', 0, 4)
x(/����|����/, '����', 0, 4)
x(/��(?:����|����)/, '�򤫤�', 0, 6)
x(/��(?:����|����)��/, '�򤭤���', 0, 8)
x(/����|(?:����|����)/, '����', 0, 4)
x(/��|��|��/, '����', 2, 4)
x(/��|��|����|������|��|������|������|��|����|�ĤƤȤʤ�|�̤�/, '������', 0, 6)
n(/��|��|����|������|��|������|������|��|����|�ĤƤȤʤ�|�̤�/, '����')
x(/��|^��/, '�֤�', 2, 4)
x(/��|^��/, '��', 0, 2)
x(/��|\G��/, '���ֵ�', 4, 6)
x(/��|\G��/, '�ֵ�', 0, 2)
x(/��|\A��/, 'b�ֵ�', 3, 5)
x(/��|\A��/, '��', 0, 2)
x(/��|��\Z/, '�ֵ�', 2, 4)
x(/��|��\Z/, '��', 0, 2)
x(/��|��\Z/, "��\n", 0, 2)
x(/��|��\z/, '�ֵ�', 2, 4)
x(/��|��\z/, '��', 0, 2)
x(/(?u)\w|\s/, '��', 0, 2)
x(/(?u)\w|%/, '%��', 0, 1)
x(/(?u)\w|[&$]/, '��&', 0, 2)
x(/[��-��]/, '��', 0, 2)
x(/[��-��]|[^��-��]/, '��', 0, 2)
x(/[��-��]|[^��-��]/, '��', 0, 2)
x(/[^��]/, "\n", 0, 1)
x(/(?:��|[��-��])|����/, '����', 0, 2)
x(/(?:��|[��-��])|����/, '����', 0, 4)
x(/������|(?=����)..��/, '������', 0, 6)
x(/������|(?!����)..��/, '������', 0, 6)
x(/(?=��)..��|(?=���)..��/, '���', 0, 6)
x(/(?<=��|����)��/, '������', 4, 6)
n(/(?>��|������)��/, '��������')
x(/(?>������|��)��/, '��������', 0, 8)
x(/��?|��/, '��', 0, 2)
x(/��?|��/, '��', 0, 0)
x(/��?|��/, '', 0, 0)
x(/��*|��/, '����', 0, 4)
x(/��*|��*/, '����', 0, 0)
x(/��*|��*/, '����', 0, 2)
x(/[a��]*|��*/, 'a��������', 0, 3)
x(/��+|��*/, '', 0, 0)
x(/��+|��*/, '������', 0, 6)
x(/��+|��*/, '��������', 0, 2)
x(/��+|��*/, 'a��������', 0, 0)
n(/��+|��+/, '')
x(/(��|��)?/, '��', 0, 2)
x(/(��|��)*/, '����', 0, 4)
x(/(��|��)+/, '������', 0, 6)
x(/(����|����)+/, '������������', 0, 8)
x(/(����|����)+/, '������������', 4, 12)
x(/(����|����)+/, '����������', 2, 10)
x(/(����|����)+/, '�����򤦤�', 0, 4)
x(/(����|����)+/, '$$zzzz�����򤦤�', 6, 10)
x(/(��|������)+/, '����������', 0, 10)
x(/(��|������)+/, '����', 2, 4)
x(/(��|������)+/, '������������', 2, 8)
x(/(?:��|��)(?:��|��)/, '����', 0, 4)
x(/(?:��*|��*)(?:��*|��*)/, '������������', 0, 6)
x(/(?:��*|��*)(?:��+|��+)/, '������������', 0, 12)
x(/(?:��+|��+){2}/, '������������', 0, 12)
x(/(?:��+|��+){1,2}/, '������������', 0, 12)
x(/(?:��+|\A��*)����/, '����', 0, 4)
n(/(?:��+|\A��*)����/, '��������')
x(/(?:^��+|��+)*��/, '����������������', 12, 16)
x(/(?:^��+|��+)*��/, '��������������', 0, 14)
x(/��{0,}/, '��������', 0, 8)
x(/��|(?i)c/, 'C', 0, 1)
x(/(?i)c|��/, 'C', 0, 1)
x(/(?i:��)|a/, 'a', 0, 1)
n(/(?i:��)|a/, 'A')
x(/[������]?/, '������', 0, 2)
x(/[������]*/, '������', 0, 6)
x(/[^������]*/, '������', 0, 0)
n(/[^������]+/, '������')
x(/��??/, '������', 0, 0)
x(/����??��/, '������', 0, 6)
x(/��*?/, '������', 0, 0)
x(/����*?/, '������', 0, 2)
x(/����*?��/, '��������', 0, 8)
x(/��+?/, '������', 0, 2)
x(/����+?/, '������', 0, 4)
x(/����+?��/, '��������', 0, 8)
x(/(?:ŷ?)??/, 'ŷ', 0, 0)
x(/(?:ŷ??)?/, 'ŷ', 0, 0)
x(/(?:̴?)+?/, '̴̴̴', 0, 2)
x(/(?:��+)??/, '������', 0, 0)
x(/(?:��+)??��/, '��������', 0, 8)
i(/(?:����)?{2}/, '', 0, 0)   # GNU regex bug
x(/(?:����)?{2}/, '���ֵ��ֵ�', 0, 8)
x(/(?:����)*{0}/, '���ֵ��ֵ�', 0, 0)
x(/(?:����){3,}/, '���ֵ��ֵ��ֵ���', 0, 16)
n(/(?:����){3,}/, '���ֵ���')
x(/(?:����){2,4}/, '���ֵ��ֵ���', 0, 12)
x(/(?:����){2,4}/, '���ֵ��ֵ��ֵ��ֵ���', 0, 16)
x(/(?:����){2,4}?/, '���ֵ��ֵ��ֵ��ֵ���', 0, 8)
x(/(?:����){,}/, '����{,}', 0, 7)
x(/(?:������)+?{2}/, '������������������', 0, 12)
x(/(��)/, '��', 0, 2, 1)
x(/(�п�)/, '�п�', 0, 4, 1)
x(/((����))/, '����', 0, 4)
x(/((����))/, '����', 0, 4, 1)
x(/((����))/, '����', 0, 4, 2)
x(/((((((((((((((((((((�̻�))))))))))))))))))))/, '�̻�', 0, 4, 20)
x(/(����)(����)/, '��������', 0, 4, 1)
x(/(����)(����)/, '��������', 4, 8, 2)
x(/()(��)����(������)��������/, '��������������������', 6, 12, 3)
x(/(()(��)����(������)��������)/, '��������������������', 6, 12, 4)
x(/.*(�ե�)�󡦥�(��()���奿)����/, '�ե��󡦥ޥ󥷥奿����', 10, 18, 2)
x(/(^��)/, '��', 0, 2)
x(/(��)|(��)/, '����', 2, 4, 1)
x(/(^��)|(��)/, '����', 2, 4, 2)
x(/(��?)/, '������', 0, 2, 1)
x(/(��*)/, '�ޤޤ�', 0, 6, 1)
x(/(��*)/, '', 0, 0, 1)
x(/(��+)/, '��������', 0, 14, 1)
x(/(��+|��*)/, '�դդդؤ�', 0, 6, 1)
x(/(��+|��?)/, '����������', 0, 2, 1)
x(/(������)?/, '������', 0, 6, 1)
x(/(������)*/, '������', 0, 6, 1)
x(/(������)+/, '������', 0, 6, 1)
x(/(������|������)+/, '������', 0, 6, 1)
x(/([�ʤˤ�][������]|������)+/, '������', 0, 6, 1)
x(/((?i:������))/, '������', 0, 6, 1)
x(/((?m:��.��))/, "��\n��", 0, 5, 1)
x(/((?=����)��)/, '����', 0, 2, 1)
x(/������|(.������)/, '�󤢤���', 0, 8, 1)
x(/��*(.)/, '����������', 8, 10, 1)
x(/��*?(.)/, '����������', 0, 2, 1)
x(/��*?(��)/, '����������', 8, 10, 1)
x(/[������]��*(.)/, '������������', 10, 12, 1)
x(/(\A����)����/, '��������', 0, 4, 1)
n(/(\A����)����/, '�󤤤�����')
x(/(^����)����/, '��������', 0, 4, 1)
n(/(^����)����/, '�󤤤�����')
x(/����(���$)/, '�������', 4, 8, 1)
n(/����(���$)/, '��������')
x(/(̵)\1/, '̵̵', 0, 4)
n(/(̵)\1/, '̵��')
x(/(��?)\1/, '����', 0, 4)
x(/(��??)\1/, '����', 0, 0)
x(/(��*)\1/, '����������', 0, 8)
x(/(��*)\1/, '����������', 0, 4, 1)
x(/��(��*)\1/, '����������', 0, 10)
x(/��(��*)\1/, '����', 0, 2)
x(/(��*)(��*)\1\2/, '��������������������', 0, 20)
x(/(��*)(��*)\2/, '��������������', 0, 14)
x(/(��*)(��*)\2/, '��������������', 6, 10, 2)
x(/(((((((��*)��))))))��\7/, '�ݤݤݤڤԤݤݤ�', 0, 16)
x(/(((((((��*)��))))))��\7/, '�ݤݤݤڤԤݤݤ�', 0, 6, 7)
x(/(��)(��)(��)\2\1\3/, '�ϤҤդҤϤ�', 0, 12)
x(/([��-��])\1/, '����', 0, 4)
x(/(?u)(\w\d\s)\1/, '��5 ��5 ', 0, 8)
n(/(?u)(\w\d\s)\1/, '��5 ��5')
x(/(ï��|[��-��]{3})\1/, 'ï��ï��', 0, 8)
x(/...(ï��|[��-��]{3})\1/, '��a��ï��ï��', 0, 13)
x(/(ï��|[��-��]{3})\1/, '������������', 0, 12)
x(/(^��)\1/, '����', 0, 4)
n(/(^��)\1/, '����')
n(/(��$)\1/, '����')
n(/(����\Z)\1/, '����')
x(/(��*\Z)\1/, '��', 2, 2)
x(/.(��*\Z)\1/, '����', 2, 4)
x(/(.(�䤤��)\2)/, 'z�䤤��䤤��', 0, 13, 1)
x(/(.(..\d.)\2)/, '��12341234', 0, 10, 1)
x(/((?i:��v��))\1/, '��v����v��', 0, 10)
x(/(?<��>��|\(\g<��>\))/, '((((((��))))))', 0, 14)
x(/\A(?:\g<��_1>|\g<��_2>|\z��λ  (?<��_1>��|��\g<��_2>��)(?<��_2>��|�\g<��_1>�))$/, '�������߼�����', 0, 26)
x(/[[�Ҥ�]]/, '��', 0, 2)
x(/[[������]��]/, '��', 0, 2)
n(/[[^��]]/, '��')
n(/[^[��]]/, '��')
x(/[^[^��]]/, '��', 0, 2)
x(/[[������]&&����]/, '��', 0, 2)
n(/[[������]&&����]/, '��')
n(/[[������]&&����]/, '��')
x(/[��-��&&��-��&&��-��]/, '��', 0, 2)
n(/[^��-��&&��-��&&��-��]/, '��')
x(/[[^��&&��]&&��-��]/, '��', 0, 2)
n(/[[^��&&��]&&��-��]/, '��')
x(/[[^��-��&&��������]&&[^��-��]]/, '��', 0, 2)
n(/[[^��-��&&��������]&&[^��-��]]/, '��')
x(/[^[^������]&&[^������]]/, '��', 0, 2)
x(/[^[^������]&&[^������]]/, '��', 0, 2)
n(/[^[^������]&&[^������]]/, '��')
x(/[��-&&-��]/, '-', 0, 1)
x(/[^[^a-z������]&&[^bcdefg������]q-w]/, '��', 0, 2)
x(/[^[^a-z������]&&[^bcdefg������]g-w]/, 'f', 0, 1)
x(/[^[^a-z������]&&[^bcdefg������]g-w]/, 'g', 0, 1)
n(/[^[^a-z������]&&[^bcdefg������]g-w]/, '2')
x(/a<b>�С������Υ����������<\/b>/, 'a<b>�С������Υ����������</b>', 0, 32)
x(/.<b>�С������Υ����������<\/b>/, 'a<b>�С������Υ����������</b>', 0, 32)

r(/��/, '��', 0)
r(/��/, '��', 0, 2)
r(/��/, '������', 2)
r(/��/, '������', 2, 4)
r(/./, '��', 0)
r(/.*/, '���������� ������', 17)
r(/.*����/, '���������� ������', 6)
r(/��*/, '������������', 12)
r(/��+/, '������������', 4)
r(/��?/, '������', 6)
r(/��??/, '������', 6)
r(/a��c��e/, 'a��c��eavcd', 0)
r(/(?u)\w\d\s/, '  ��2 ���� $3 ', 2)
r(/[��-��]����[��-��]/, '3�������ʤ�������', 1)
r(/��|��/, '��', 0)
r(/����|����|����/, '������', 0)
r(/(�ȤȤ�)\1/, '�ȤȤ��ȤȤ��ȤȤ�', 6)
r(/|��/, '��', 2)
r(/^����/, '��������', 0)
r(/����$/, '��������', 4)
r(/(((.��)))\3/, 'z��z������', 0)
r(/(����*?��)\1/, '���������󤢤����󤢤���', 2)
r(/������{3,4}/, '�ƤƤ��������������󤢤��󤢤���', 12)
r(/\000��/, "��\000��", 2)
r(/�Ȥ�\xfe\xfe/, "�ȤȤ�\xfe\xfe", 2)
r(/...������������������������������/, 'zzzzz������������������������������', 2)
end

test_sb('ASCII')
test_sb('EUC')
test_sb('SJIS')
test_sb('UTF-8')
test_euc('EUC')


# UTF-8   (by UENO Katsuhiro)
$KCODE = 'UTF-8'

x(/\w/u, "\xc3\x81", 0, 2)
n(/\W/u, "\xc3\x81")
x(/[\w]/u, "\xc3\x81", 0, 2)
x(/./u, "\xfe", 0, 1)
x(/\xfe/u, "\xfe", 0, 1)
x(/\S*/u, "\xfe", 0, 1)
x(/\s*/u, "\xfe", 0, 0)
n(/\w+/u, "\xfe")
x(/\W+/u, "\xfe\xff", 0, 2)
x(/[\xfe]/u, "aaa\xfe", 3, 4)
x(/[\xff\xfe]/u, "\xff\xfe", 0, 1)
x(/[a-c\xff\xfe]+/u, "\xffabc\xfe", 0, 5)

s = "\xe3\x81\x82\xe3\x81\x81\xf0\x90\x80\x85\xe3\x81\x8a\xe3\x81\x85"
x(/[\xc2\x80-\xed\x9f\xbf]+/u, s, 0, 6)

s = "\xf0\x90\x80\x85\xe3\x81\x82"
x(/[\xc2\x80-\xed\x9f\xbf]/u, s, 4, 7)

s = "\xed\x9f\xbf"
n(/[\xc2\x80-\xed\x9f\xbe]/u, s)

s = "\xed\x9f\xbf"
n(/[\xc2\x80-\xed\x9f\xbe]/u, s)

s = "\xed\x9f\xbf"
n(/[\xc2\x80-\xed\x9f\xbe]/u, s)

s = "\xed\x9f\xbf"
n(/[\xc3\xad\xed\x9f\xbe]/u, s)

s = "\xed\x9f\xbf"
n(/[\xc4\x80-\xed\x9f\xbe]/u, s)

s = "\xed\x9f\xbf\xf0\x90\x80\x85\xed\x9f\xbf"
x(/[^\xc2\x80-\xed\x9f\xbe]/u, s, 0, 3)

s = "\xed\x9f\xbf"
x(/[^\xc3\xad\xed\x9f\xbe]/u, s, 0, 3)

s = "\xed\x9f\xbf\xf0\x90\x80\x85\xed\x9f\xbf"
x(/[^\xc4\x80-\xed\x9f\xbe]/u, s, 0, 3)

s = "\xc3\xbe\xc3\xbf"
n(/[\xfe\xff\xc3\x80]/u, s)

s = "\xc3\xbe"
x(/[\xc2\xa0-\xc3\xbe]/u, s, 0, 2)

s = "sssss"
x(/s+/iu, s, 0, 5)

s = "SSSSS"
x(/s+/iu, s, 0, 5)

reg = Regexp.new("\\x{fb40}", nil, 'u')
x(reg, "\357\255\200", 0, 3)
x(/\A\w\z/u, "\357\255\200", 0, 3)
x(/\A\W\z/u, "\357\255\202", 0, 3)
n(/\A\w\z/u, "\357\255\202")

x(/\303\200/iu, "\303\240", 0, 2)
x(/\303\247/iu, "\303\207", 0, 2)



# Japanese long text.
$KCODE = 'EUC'

s = <<EOS
�������ܤˤ����Ƥϡ��췳�ˤĤ��Ƥ�Ĵ���˴�Ť�����Ƚ����������Ĭ��������
���Ȥ��л���Ȭǯ����ʼ�Ƥ�����ǯ����Ϫ����ν��ä�ǯ�Ǥ��뤳�Ȥ��äƷڹ���
�췳�ε켰�֤���ĥ������ɾ���ޤ���Ȥ��äƤ��롣
ͭ̾�����ԤȤ��Ƥϡ��Ρ���������Ϻ��󤲤뤳�Ȥ��Ǥ����������

ʼƬ��Ȭ ��ͭ��ơ� ��ë�饦��� (1998)
EOS

x(/\((.+)\)/, s, 305, 309, 1)
x(/��������Ϻ/, s, 229, 239)
x(/��$/, s, 202, 204)
x(/(^ʼƬ..Ȭ)/, s, 269, 279, 1)
x(/^$/, s, 268, 268)


s = <<EOS
���ʤ�����޻��ϰ���ʸ���Ǥ���������
�⤷���ȤФ򤷤뤹��Τ�ʸ���Ǥ���Ȥ���ȡ�����Ϥ��ȤФ򤷤뤹��ΤǤϤʤ���
�ܤ�book�Ϥ��ȤФǤ��뤬���ۥ��hon�ϲ���ʤ�٤������ǡ���ʬ��ñ������
��Ĥ�ΤǤϤʤ���
ñ��Ȥ��Ƥ�����η��֤�⤿�ʤ�����Ǥ��롣
�ַ��ˤ���פ򥢥��ϴ������Ф������Ū�ʰ�̣���Ѥ�������
���Τʤ���Τ������ϸ�ǤϤ��ꤨ�ʤ��ΤǤ��롣

������ �ִ���ɴ�á�
EOS

n(/\((.+)\)/, s)
x(/��(.*)��/, s, 254, 264, 1)
x(/��$/, s, 34, 36)
x(/(book)/, s, 120, 124, 1)
x(/^$/, s, 360, 360)


s = <<EOS
��ब�û��ˤ����äƤ����Ȥ���С����Τ��Ӥ�������̩�����Ѥ��̤ȡ�
���μ��ι⤵�ˤ��ɤ����ˤ������ʤ���
���γмԤ�������Ū�ʶä����ĤΤϡ�����ư�������������Ω�ä��Ȥ���������
�ݡ� ����ϡ��ɥ�������ͤξ�ǯ����ǤϤʤ�����

��������Ϻ �ֱû����Ѥ�Ÿ������ư�����ˤդ�Ĥġ� �����ҥ����(1986)
EOS

x(/\((.+)\)/, s, 290, 296)
x(/��(.*)��(.+)��/, s, 257, 275, 2)
x(/^�ݡ� /, s, 179, 184)
x(/(���)/, s, 0, 4, 1)
x(/\w��/, s, 30, 34)


s = <<EOS
���Ȥ��äơ������ϡ����ⷯ�⡢���䷯�⡢�����Ƥ⤦��ͤο�ʪ�⡢������̤ˤ����ʤ����Ȥ򡢤����輷���ǡ�¤�ʪ��äƤ��롣
����黰�ͤξ���ϰ�Ԥ�ФƤ��ʤ��Τ���
�񤯤Ҥޤ��ʤ��ä��ΤǤ�������
������������ֶ������áפ����ʤ���Ȭ��������ФĤŤ��Ƥ椯�Ǥ��������ȤˤĤ��Ƥϡ���Ϥ֤��ߤʤۤɤγο����äƤ��롣���λ���ˤϡ���̳ǽ�Ϥ���ʪ�Τ褦�ʿ�ʪ�������ͤ⤤�롣
�����פ��ȡ��Ȥ��ɤ�����©�νФ�褦�ʤ��⤤������ΤǤ��롣

��������Ϻ �֤���ʻ�����Ƥ��ޤ������� �������� �輷�� (1961)
EOS

x(/\((\d+)\)/, s, 496, 502)
x(/(��.+����.*��)/, s, 449, 479, 1)
x(/��(.)��/, s, 96, 98, 1)
x(/��$/, s, 120, 122)
x(/��������/, s, 209, 217)


s = <<EOS
�󽽸��ܤ�ۤ���������̤β�������й������Ω�Ƥ˿��Ť�꤬���ä��Τϡ������ĤäƤ����ͽ������ϲ�����䲰�Τ������������ò���ʼ�Ҥ�����ͤ��ä���
������ϲ�����Ȥ��äƤ⡢���;����󲰤�Ǽ��������ѱ��ȡ����ͻ����ή����ΤȤ�����Ʊ��ʪ�ǤϤʤ��ä���
���⤽�⤬��ʪ�������Ȥ��ƹͤ���줿�������ϡ�͢�������ޤ˶��ʬ���Ϥ������ܸ��ꤷ���ΤǤ��äˤʤ�ʤ��������ǡ����;��Ǽ����Τϡ��Ƥ������������ư����Ϥ��ˤ����������Ѥ߾夲�����ʬ��ȴ���ƿ����˻�Ω�ƾ夲����Τ��ä���

�����°� �ֻ���Ļ���� (2000)
EOS

x(/\((\d+)\)/, s, 506, 512)
x(/(��.*��)/, s, 493, 505, 1)
x(/������/, s, 292, 298)


s = <<EOS
�����������ܿͤ������Ф����Ѥ�ä����٤�΢�ˤϡ����Ĥϡ�
��Ӥ��������बƯ���Ƥ�����
����ϡ�������郎�ּ�ʼ����˸����뤫�ɤ����פǤ��ä���

ʼƬ��Ȭ ��ͭ��ơ� ��ë�饦��� (1998)
EOS

x(/\((\d+)\)/, s, 185, 191)
x(/(��.*��)/, s, 108, 138, 1)
x(/^�����/, s, 90, 96)
x(/^.*$/, s, 0, 58)

s = <<EOS
  ɣ�Ͽͤ⿩�����Ϥλ����ˤ⤷�ޤ������Ϥˤ�ɣ�쾣��Ʀ���򤿤��Ƥޤ�����Τ�����˰��Ϥ��٤��������ʹ֤��Ͼ����Τ�Τ򤿤٤��������Ǥ���ޤ���
  �ʹ֤������ϥإ����Ӥ򤿤٤������ڤ��Ǥơ���Ǥ�����Ϥˤ�ꡢ�ڤ򤳤ޤ����ڤꡢ�ڤ�ɣ���Ƥ�ޤ��Ƥ����Ƥ��٤������ä��Τ��Ƥ�ɣ��Ⱦ�����餤�Ǥ��ä�������������ǯ��ˤʤ�ȡ�ɣ��Ĥ���Τ��ؤä���ơ�ɣ���Ƥλ�ʬ�ΰ줯�餤�ˤʤä����إ����Ӥˤϱ��򾯤����줿���Ǥ���

���ܾ�� ��˺���줿���ܿ͡� (1960)
EOS

x(/(ɣ���Ƥλ�ʬ�ΰ줯�餤��)/, s, 357, 381, 1)
x(/����ޤ���$/, s, 140, 150)
x(/  �ʹ�(.*)��/, s, 157, 423, 1)
x(/�إ�����[��Ϥ�]/, s, 165, 175)

s = <<EOS
�ȤϤ��Ȥ� ��¢�����դ˵�̤Ȥ� α�֤ޤ����º�

���ľ��� ��α��Ͽ�� (1859)
EOS

x(/\((.+)\)/, s, 68, 74)
x(/��(.*)��/, s, 59, 65, 1)
x(/^(���ľ���)/, s, 48, 56, 1)

s = <<EOS
���դޤǤ�ʤ��ǽ�˴�����ڤ��Ԣ�첻����ɽ����������ͤˤ����Ƥ⡢
�������Ť˲���Ȥ��ƤΤ�ª�ؤ��Ƥ𤿤ΤǤ��ꡢ�������Ĥ�ʸ�����Ť�
�����ɽ�����벻��ʸ���Ȥ������򤵤�Ƥ𤿤櫓�Ǥ�������ϰ���ɤ�����
���Ȥ��̣���뤫�Ȥ��դȡ�������ʸ���ˤ�Ĥ�ɽ���줿������ޤ�ۣ�桢
�԰���Τ�ΤǤ������ꤨ�ʤ��Ȥ��դ��Ȥ��̣���ޤ��������ˤ����Ƥ⡢
����Ԣ�첻��������ʸ�������ʡ��ڤ����Ԥδط��Ͼ������Τ餺�������Ȥ���
����ʸ���ϻ䤿�����԰���ʲ�����ɽ������Τ˺Ǥ�դ��Ϥ����԰����ʸ��
�Ǥ��ꡢ���Ū���ʤŤ��ҤϤ�������Ԣ�첻���������˺Ǥ�Ŭ�礷��ɽ��ˡ��
����ȸ��ؤޤ����Ĥޤꡢ���Ū���ʤŤ��Ҥ�ɽ��Ū�Ǥʤ����Ȥ���ʿ��
��餹�ޤؤˡ��͡��ϤޤŤ���ʸ����ɽ����Ŭ���̤��Ȥ���ʿ����դ٤���
���ꡢ�������Ĥơ�Ԣ�첻�����Τ�Τ�ɽ������ݤ��Ƥ�뤳�Ȥ����ܤ�
�٤��Ǥ���ޤ���

ʡ����¸ �ֻ��Ԣ�춵����
EOS

x(/Ԣ�춵��/, s, 800, 808)
x(/�𤿤櫓�Ǥ�/, s, 176, 188)

s = <<EOS
���������ȥ����󥹥��������ܳ�����ˤĤ��ơ����ˤ��줿������
��������Ǥ��롣�����ˡ��������ƻ�ˡ�Ϳ����줿���Ϥ�����¤ꡢ
��ᤫ�龡�����Բ�ǽ���ä����������Ƥ��롣
���뤤�ϥ˥��饤�������Ф��븷���������ޤ�Ĥ����ä��Τ���
����ʤ���
����ʹߡ������������ܳ�����ˤĤ��Ƥ���ɾ�ϡ�
�ּ�ˤȯ��®�١סֲ��������ס�Ű���ƻ��ѡפʤɤˡ��԰��򵢤�
�褦�ˤʤä���

�̵���ϯ �ֺ֡�ξ�α��פǤ�ʬ����ʤ����ܳ������ ���ڽ�˼ (2005)
EOS

x(/\A(.*)�����ܳ�����ˤĤ���/, s, 0, 22, 1)
x(/��(.*?)��[^��]*��(.+?)��[^��]*��(?:.*?)��/, s, 290, 332)
x(/��{1,2}(?=��)/, s, 28, 32)

# result
printf("\n*** SUCCESS: %d,  FAIL: %d    Ruby %s (%s) [%s] ***\n",
       $rok, $rfail, RUBY_VERSION, RUBY_RELEASE_DATE, RUBY_PLATFORM)

# END.
