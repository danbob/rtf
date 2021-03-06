require 'stringio'

module RTF
  # This class represents a row within an RTF table. The TableRowNode is a
  # specialised container node that can hold only TableCellNodes and, once
  # created, cannot be resized. Its also not possible to change the parent
  # of a TableRowNode object.
  class TableRowNode < ContainerNode
    # This is the constructor for the TableRowNode class.
    #
    # ===== Parameters
    # table::   A reference to table that owns the row.
    # cells::   The number of cells that the row will contain.
    # widths::  One or more integers specifying the widths for the table
    #           columns
    def initialize(table, cells, *widths)
      super(table) do
        children = []
        cells.times do |index|
          children.push(TableCellNode.new(self, widths[index]))
        end
        children
      end
    end

    # Attribute accessors
    def length
      children.size
    end

    # This method assigns a border width setting to all of the sides on all
    # of the cells within a table row.
    #
    # ==== Parameters
    # width::  The border width setting to apply. Negative values are ignored
    #          and zero switches the border off.
    def border_width=(width)
      self.each {|cell| cell.border_width = width}
    end

    # This method overloads the parent= method inherited from the Node class
    # to forbid the alteration of the cells parent.
    #
    # ==== Parameters
    # parent::  A reference to the new node parent.
    def parent=(parent)
      raise RTF::RTFError, 'Table row nodes cannot have their parent changed.'
    end

    # This method sets the shading color for a row.
    #
    # ==== Parameters
    # color::  A reference to the Color object that represents the new
    #           shading color. Set to nil to switch shading off.
    def shading_color=(color)
      self.each {|cell| cell.shading_color = color}
    end

    # This method overloads the store method inherited from the ContainerNode
    # class to forbid addition of further nodes.
    #
    # ==== Parameters
    # node::  A reference to the node to be added.
    def store(node)
      raise RTF::RTFError, 'Table row nodes cannot have nodes added to.'
    end

    # This method generates the RTF document text for a TableCellNode object.
    def to_rtf
      text   = StringIO.new
      temp   = StringIO.new
      offset = 0

      text << "\\trowd\\tgraph#{parent.cell_margin}"
      self.each do |entry|
        widths = entry.border_widths
        color = entry.shading_color

        text << "\n"
        text << "\\clbrdrt\\brdrw#{widths[0]}\\brdrs" if widths[0] != 0
        text << "\\clbrdrl\\brdrw#{widths[3]}\\brdrs" if widths[3] != 0
        text << "\\clbrdrb\\brdrw#{widths[2]}\\brdrs" if widths[2] != 0
        text << "\\clbrdrr\\brdrw#{widths[1]}\\brdrs" if widths[1] != 0
        text << "\\clcbpat#{root.colors.index(color)}" if color != nil
        text << "\\cellx#{entry.width + offset}"
        temp << "\n#{entry.to_rtf}"
        offset += entry.width
      end
      text << "#{temp.string}\n\\row"

      text.string
    end
  end
end