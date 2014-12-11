##
# title: SemesterInfoView
# by: Brian Kim
# description: the view that displays the informattion
#   about a semester
#

import pygtk
pygtk.require('2.0')
import gtk

from breadinterface import lifecycle

class SemesterInfoView( gtk.Alignment, lifecycle ):
  class DataSource():
    def season( self ):
      return ''
    def year( self ):
      return ''

  def get_season( self ):
    return self.season_entry.get_text()

  def get_year( self ):
    return int(self.year_entry.get_text())

  def update( self ):
    self.season_entry.set_text( self.ds.season() )
    self.year_entry.set_text( str(self.ds.year()) )

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
    season_label = gtk.Label( 'Season:' )
    self.season_entry = gtk.Entry()
    # year
    year_label = gtk.Label( 'Year:' )
    self.year_entry = gtk.Entry()
    # add components to vbox
    self.inner.add(season_label)
    self.inner.add(self.season_entry)
    self.inner.add(year_label)
    self.inner.add(self.year_entry)
    # add vbox to alignment
    self.add( self.inner )

if __name__ == "__main__":
  w = gtk.Window()
  w.add( SemesterInfoView() )
  w.show_all()
  gtk.main()
