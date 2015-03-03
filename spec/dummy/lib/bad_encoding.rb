# coding: utf-8
class SomeClass
  def initialize(_a, _b, _c)
    "hey, invalid ASCII\xED"
  end
end
