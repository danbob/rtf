require 'stringio'

module RTF
  # This class represents a font for use with some RTF content.
  class Font
    # Available font families:
    # :modern - monospaced fonts (e.g. Courier New)
    # :roman - proportionally spaced serif fonts (e.g. Arial, Times New Roman)
    # :swiss - proportionally spaced sans serif fonts (e.g. Tahoma, Lucida Sans)
    # :nil - any other font family

    # Attribute accessor.
    attr_reader :family, :name

    # This is the constructor for the Font class.
    #
    # ==== Parameters
    # family::  The font family for the new font. This should be one of
    #           :modern, :roman, :swiss or
    #           :nil.
    # name::    A string containing the font name.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever an invalid font family is specified.
    def initialize(family, name)
      # Check that a valid family has been provided.
      if !%w(modern roman swiss nil).include?(family.to_s)
        raise RTF::RTFError, 'Unknown font family specified for Font object.'
      end
      @family = family
      @name   = name
    end

    # This method overloads the equivalence test operator for the Font class
    # to allow for Font comparisons.
    #
    # ==== Parameters
    # object::  A reference to the object to be compared with.
    def ==(object)
      object.instance_of?(Font) &&
      object.family == @family &&
      object.name   == @name
    end

    # This method fetches a textual description for a Font object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines generated by the
    #           method. Defaults to zero.
    def to_s(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}Family: #{@family}, Name: #{@name}"
    end

    # This method generates the RTF representation for a Font object as it
    # would appear within a document font table.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines generated by the
    #           method. Defaults to zero.
    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}\\f#{@family} #{@name};"
    end
  end
end
