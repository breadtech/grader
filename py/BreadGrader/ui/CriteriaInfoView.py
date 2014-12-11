##
# title: CriteriaInfoView
# by: Brian Kim
# description: the view that displays the informattion
#   about a criteria
#

import pygtk
pygtk.require('2.0')
import gtk

from BreadInterface import Lifecycle

class CriteriaInfoView( gtk.Alignment, Lifecycle ):
  class DataSource():
    def type( self ):
      return ''
    def weight( self ):
      return ''

  def get_type( self ):
    return self.type_entry.get_text()

  def get_weight( self ):
    return self.weight_entry.get_text()

  def update( self ):
    self.type_entry.set_text( self.ds.type() )
    self.weight_entry.set_text( str(self.ds.weight()) )

  def __init__( self, ds=DataSource() ):
    # setting the datasource
    self.ds = ds
    # calling the super class's constructor
    gtk.Alignment.__init__( self, 0.2, 0.2, 0.9, 0.9 )
    # setting the padding
    self.set_padding( 5, 5, 5, 5 )
    # building the ui
    self.inner = gtk.VBox()
    # season
    type_label = gtk.Label( 'Type:' )
    self.type_entry = gtk.Entry()
    # year
    weight_label = gtk.Label( 'Weight:' )
    self.weight_entry = gtk.Entry()
    # add components to vbox
    self.inner.add(type_label)
    self.inner.add(self.type_entry)
    self.inner.add(weight_label)
    self.inner.add(self.weight_entry)
    # add vbox to alignment
    self.add( self.inner )

if __name__ == "__main__":
  w = gtk.Window()
  w.add( CriteriaInfoView() )
  w.show_all()
  gtk.main()
