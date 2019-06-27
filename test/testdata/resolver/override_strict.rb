# typed: strict

class Abstract
  extend T::Sig
  extend T::Helpers

  abstract!
  sig { abstract.returns(Integer) }
  def foo; end
end

class BadImpl < Abstract
  sig { returns(Integer) }
  def foo; 99; end # error: Method `BadImpl#foo` overrides `Abstract#foo` but lacks an explicit `override`
end

class GoodImpl < Abstract
  sig { override.returns(Integer) }
  def foo; 99; end
end

module Interface
  extend T::Sig
  extend T::Helpers

  interface!
  sig { abstract.returns(Integer) }
  def bar; end
end

class BadInterImpl
  extend T::Sig
  include Interface
  sig { returns(Integer) }
  def bar; 99; end # error: Method `BadInterImpl#bar` overrides `Interface#bar` but lacks an explicit `override`
end

class GoodInterImpl
  extend T::Sig
  include Interface
  sig { override.returns(Integer) }
  def bar; 99; end
end

class BadOverride
  extend T::Sig

  sig { override.returns(Integer) }
  def baz; 99; end # error: Method `BadOverride#baz` is declared `override` but does not override a method
end

