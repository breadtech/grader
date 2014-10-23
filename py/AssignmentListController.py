##
# title: AssignmentListControlleer
# by: Brian Kim
# description: a list controller for the assignment object
#

import pygtk
pygtk.require('2.0')
import gtk

import breadinterface

class AssignmentListController( breadinterface.Controller )
  class AssignmentListView( gtk.TreeView ):
    def __init__( self, model=gtk.ListStore( int, str, str, str, ) ):
      # init the obj
      gtk.TreeView.__init__( self, model )

      # init the cols
      rt = gtk.CellRenderText()
      col = gtk.TreeViewColumn( "#", rt, text=0 )
      col.set_sort_column_id( 0 )
      self.append_column( col )

      rt = gtk.CellRenderText()
      col = gtk.TreeViewColumn( "name", rt, text=1 )
      col.set_sort_column_id( 1 )
      self.append_column( col )

      rt = gtk.CellRenderText()
      col = gtk.TreeViewColumn( "due date", rt, text=2 )
      col.set_sort_column_id( 2 )
      self.append_column( col )

      rt = gtk.CellRenderText()
      col = gtk.TreeViewColumn( "grade", rt, text=3 )
      col.set_sort_column_id( 3 )
      self.append_column( col )

