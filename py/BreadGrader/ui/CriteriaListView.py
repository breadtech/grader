##
# title: CriteriaListView
# by: Brian Kim
# description: the view that displays a list of criterias
#

import pygtk
pygtk.require('2.0')
import gtk

from breadinterface import lifecycle

class CriteriaListView( gtk.ScrolledWindow, lifecycle ):
  class Delegate():
    def n_criterias( self ):
      return 1
    def criteria_clicked_at( self, index ):
      pass

  class DataSource():
    def type_at_index( self, i ):
      return 'Test'
    def weight_at_index( self, i ):
      return 20
    def avg_at_index( self, i ):
      return '100.0%'

  def selected_index( self ):
    sel = self._list.get_selection()
    sel = sel[0] if len(sel)>0 else None
    return self._list.child_position( sel ) if sel else None

  def item_clicked( self, lst, event ):
    if event.type == gtk.gdk.BUTTON_RELEASE and event.button == 3:
      i = self.selected_index()
      if not i == None:
        self.dg.criteria_clicked_at( self.selected_index() ) 

  def clear( self ):
    for child in self._list.get_children():
      self._list.remove(child)

  def update( self ):
    self.clear()
    n = self.dg.n_criterias()
    for i in range(n):
      # left: title
      left = gtk.Alignment()
      left.set_padding( 10, 10, 10, 80 )
      msg = self.ds.type_at_index(i) + ' (' + str(self.ds.weight_at_index(i)) + '%)'
      left.add( gtk.Label( msg ))
      # right: grade
      right = gtk.Alignment()
      right.set_padding( 10, 10, 80, 10 )
      right.add( gtk.Label( self.ds.avg_at_index(i)))
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
  lv = CriteriaListView()
  w.add( lv )
  w.show_all()
  lv.update()
  gtk.main()
