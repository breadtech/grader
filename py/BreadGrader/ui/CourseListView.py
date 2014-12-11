##
# title: CourseListView
# by: Brian Kim
# description: the view that displays a list of courses
#

import pygtk
pygtk.require('2.0')
import gtk

from breadinterface import lifecycle

class CourseListView( gtk.ScrolledWindow, lifecycle ):
  class Delegate():
    def n_courses( self ):
      return 1
    def course_clicked_at( self, index ):
      pass

  class DataSource():
    def title_at_index( self, i ):
      return 'Calculus'
    def grade_at_index( self, i ):
      return '100.0%'

  def selected_index( self ):
    return self._list.child_position( self._list.get_selection()[0] )

  def item_clicked( self, lst, event ):
    if event.type == gtk.gdk.BUTTON_RELEASE and event.button == 3:
      self.dg.course_clicked_at( self.selected_index() )

  def clear( self ):
    for child in self._list.get_children():
      self._list.remove(child)

  def update( self ):
    self.clear()
    n = self.dg.n_courses()
    for i in range(n):
      # left: title
      left = gtk.Alignment()
      left.set_padding( 5, 5, 5, 50 )
      left.add( gtk.Label( self.ds.title_at_index(i) ))
      # right: grade
      right = gtk.Alignment()
      right.set_padding( 5, 5, 50, 5 )
      right.add( gtk.Label( self.ds.grade_at_index(i) ))
      # for proper spacing...
      hbox = gtk.HBox()
      hbox.pack_start(left)
      hbox.pack_start(right)
      # add to item
      item = gtk.ListItem()
      item.add(hbox)
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
  lv = CourseListView()
  w.add( lv )
  w.show_all()
  lv.update()
  gtk.main()
