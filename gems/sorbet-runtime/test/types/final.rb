# frozen_string_literal: true
require_relative '../test_helper'

class Opus::Types::Test::FinalTest < Critic::Unit::UnitTest
  after do
    T::Private::DeclState.current.reset!
  end

  it "allows declaring a class as final" do
    Class.new do
      extend T::Helpers
      final!
    end
  end

  it "allows declaring a module as final" do
    Module.new do
      extend T::Helpers
      final!
    end
  end

  it "allows declaring an instance method as final" do
    Class.new do
      extend T::Sig
      sig {void}.final
      def foo; end
    end
  end

  it "allows declaring a class method as final" do
    Class.new do
      extend T::Sig
      sig {void}.final
      def self.foo; end
    end
  end

  it "forbids inheriting from a final class" do
    c = Class.new do
      extend T::Helpers
      final!
    end
    err = assert_raises(RuntimeError) do
      Class.new(c)
    end
    assert_includes(err.message, "was declared as final and cannot be inherited from")
  end

  it "forbids redefining a final instance method" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig {void}.final
        def foo; end
        sig {void}.final
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids redefining a final class method" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Sig
        sig {void}.final
        def self.foo; end
        sig {void}.final
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end

  it "forbids overriding a final instance method" do
    c = Class.new do
      extend T::Sig
      sig {void}.final
      def foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new(c) do
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids overriding a final class method" do
    c = Class.new do
      extend T::Sig
      sig {void}.final
      def self.foo; end
    end
    err = assert_raises(RuntimeError) do
      Class.new(c) do
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and cannot be overridden")
  end

  it "forbids declaring a class as final and its instance method as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        extend T::Sig
        sig {void}.final
        def foo; end
      end
    end
    assert_includes(err.message, "was declared as final and its method")
    assert_includes(err.message, "cannot also be explicitly declared as final (it is implicitly final)")
  end

  it "forbids declaring a class as final and its instance method as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        extend T::Sig
        sig {void}.final
        def self.foo; end
      end
    end
    assert_includes(err.message, "was declared as final and its method")
    assert_includes(err.message, "cannot also be explicitly declared as final (it is implicitly final)")
  end

  it "forbids declaring a class as final and then abstract" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        abstract!
      end
    end
    assert_includes(err.message, "was already declared as final and cannot be declared as abstract")
  end

  it "forbids declaring a class as abstract and then final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        abstract!
        final!
      end
    end
    assert_includes(err.message, "was already declared as abstract and cannot be declared as final")
  end

  it "forbids re-declaring a class as final" do
    err = assert_raises(RuntimeError) do
      Class.new do
        extend T::Helpers
        final!
        final!
      end
    end
    assert_includes(err.message, "was already declared as final and cannot be re-declared as final")
  end

  it "forbids declaring a non-module, non-method as final" do
    err = assert_raises(RuntimeError) do
      Array.new(1) do
        extend T::Helpers
        final!
      end
    end
    assert_includes(err.message, "is not a module or method and cannot be declared as final")
  end

  it "marks the methods of a final module as final" do
    mod = Module.new do
      extend T::Helpers
      final!
      def self.foo; 1; end
    end
    err = assert_raises(RuntimeError) do
      def mod.foo; 2; end
    end
    assert_includes(err.message, "was declared as final and cannot be redefined")
  end
end
