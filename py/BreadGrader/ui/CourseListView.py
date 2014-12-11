##
# title: CourseListView
# by: Brian Kim
# description: the view that displays a list of courses
#

import pygtk
pygtk.require('2.0')
import gtk

from BreadInterface import Lifecycle

class CourseListView( gtk.ScrolledWindow, Lifecycle ):
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
    sel = self._list.get_selection()
    sel = sel[0] if len(sel)>0 else None
    return self._list.child_position( sel ) if sel else None

  def item_clicked( self, lst, event ):
    if event.type == gtk.gdk.BUTTON_RELEASE and event.button == 3:
      i = self.selected_index()
      if not i == None:
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
      left.set_padding( 10, 10, 10, 80 )
      left.add( gtk.Label( self.ds.title_at_index(i) ))
      # right: grade
      right = gtk.Alignment()
      right.set_padding( 10, 10, 80, 10 )
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
