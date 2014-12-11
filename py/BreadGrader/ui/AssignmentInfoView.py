##
# title: AssignmentInfoView.py
# by: Brian Kim
# description: the controller that shows information about
#   an assignment
#

import pygtk
pygtk.require('2.0')
import gtk
import time

from BreadInterface import Lifecycle

class AssignmentInfoView( gtk.Alignment, Lifecycle):
  #
  # datasource delegation
  # 
  class DataSource():
    def type( self ):
      return ''
    def index( self ):
      return 1
    def name( self ):
      return 'Limits'
    def due( self ):
      return time.time()
    def max( self ):
      return 100
    def received( self ):
      return -1
    def notes( self ):
      return ''

  # 
  # accessor methods
  # 
  def get_type( self ):
    return self.type_entry.get_text()
  def get_index( self ):
    return int(self.index_entry.get_text())
  def get_name( self ):
    return self.name_entry.get_text()
  def get_due( self ):
    return float(self.due_entry.get_text())
  def get_max( self ):
    return float(self.max_entry.get_text())
  def get_received( self ):
    return float(self.received_entry.get_text())
  def get_notes( self ):
    return self.notes_entry.get_text()

  #
  # BreadInterface lifecycle methods
  #

  def update( self ):
    self.type_entry.set_text( str(self.ds.type()))
    self.index_entry.set_text( str(self.ds.index()))
    self.name_entry.set_text( str(self.ds.name()))
    self.due_entry.set_text( str(self.ds.due()))
    self.notes_entry.set_text( str(self.ds.notes()))
    self.received_entry.set_text( str(self.ds.received()))
    self.max_entry.set_text( str(self.ds.max()))

  def __init__( self, ds=DataSource() ):
    self.ds = ds
    gtk.Alignment.__init__( self )
    self.set_padding( 5,5,5,5)
    self.table = gtk.Table(  8, 2, True )
    self.type_entry = gtk.Entry()
    self.type_entry.set_editable(False)
    self.index_entry = gtk.Entry()
    self.name_entry = gtk.Entry()
    self.due_entry = gtk.Entry()
    self.max_entry = gtk.Entry()
    self.received_entry = gtk.Entry()
    self.notes_entry = gtk.Entry()
    self.type_entry.set_editable( False )

    type_label = gtk.Label("type:")
    index_label = gtk.Label("index:")
    name_label = gtk.Label("name:")
    due_label = gtk.Label("due date:")
    max_label = gtk.Label("max:")
    received_label = gtk.Label("received:")
    notes_label = gtk.Label("notes:")

    #fill table with labels
    self.table.attach(type_label,0,1,0,1)
    self.table.attach(self.type_entry,1,2,0,1)
    self.table.attach(index_label,0,1,1,2)
    self.table.attach(self.index_entry,1,2,1,2)
    self.table.attach(name_label,0,1,2,3)
    self.table.attach(self.name_entry,1,2,2,3)
    self.table.attach(due_label,0,1,3,4)
    self.table.attach(self.due_entry,1,2,3,4)
    self.table.attach(max_label,0,1,4,5)
    self.table.attach(self.max_entry,1,2,4,5)
    self.table.attach(received_label,0,1,5,6)
    self.table.attach(self.received_entry,1,2,5,6)
    self.table.attach(notes_label,0,1,6,7)
    self.table.attach(self.notes_entry,1,2,6,7)

    # add table to alignment
    self.add(self.table)

if __name__ == "__main__":
  w = gtk.Window()
  w.add( AssignmentInfoView() )
  w.show_all()
  gtk.main()

