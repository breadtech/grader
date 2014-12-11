##
# title: SemesterListView
# by: Brian Kim
# description: the view that displays a list of semesters
#

import pygtk
pygtk.require('2.0')
import gtk

from breadinterface import lifecycle

class SemesterListView( gtk.ScrolledWindow, lifecycle ):
  class Delegate():
    def n_semesters( self ):
      return 1
    def semester_clicked_at( self, index ):
      pass

  class DataSource():
    def season_at_index( self, i ):
      return 'Fall'
    def year_at_index( self, i ):
      return 2014

  def selected_index( self ):
    return self._list.child_position( self._list.get_selection()[0] )

  def item_clicked( self, lst, event ):
    if event.type == gtk.gdk.BUTTON_RELEASE and event.button == 3:
      self.dg.semester_clicked_at( self, self.selected_index )

  def clear( self ):
    for child in self._list.get_children():
      self._list.remove(child)

  def update( self ):
    self.clear()
    n = self.dg.n_semesters()
    for i in range(n):
      val = self.ds.season_at_index(i) + ' ' + str(self.ds.year_at_index(i))
      label = gtk.Label(val)
      item = gtk.ListItem()
      item.add(label)
      self._list.add( item )
    self._list.show_all()

  def __init__( self, dg=Delegate(), ds=DataSource() ):
    # setting the delegate and datasource
    self.dg = dg
    self.ds = ds
    # calling the super class's constructor
    gtk.ScrolledWindow.__init__(self)
    # building the ui
    self._list = gtk.List()
    # set to single selection
    self._list.set_selection_mode( 1 )
    # add a selection signal handler
    self._list.connect( 'button_release_event', self.item_clicked )
    # add list to scrolled window
    self.add_with_viewport( self._list )

if __name__ == "__main__":
  w = gtk.Window()
  lv = SemesterListView()
  w.add( lv )
  w.show_all()
  lv.update()
  gtk.main()
