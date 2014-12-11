##
# title: CourseInfoView
# by: Brian Kim
# description: the view that displays the informattion
#   about a course
#

import pygtk
pygtk.require('2.0')
import gtk

from BreadInterface import Lifecycle

class CourseInfoView( gtk.Alignment, Lifecycle ):
  class DataSource():
    def the_title( self ):
      return ''
    def subject( self ):
      return ''

  def get_title( self ):
    return self.title_entry.get_text()

  def get_subject( self ):
    return self.subject_entry.get_text()

  def update( self ):
    self.title_entry.set_text( self.ds.the_title() )
    self.subject_entry.set_text( str(self.ds.subject()) )

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
    title_label = gtk.Label( 'Title:' )
    self.title_entry = gtk.Entry()
    # year
    subject_label = gtk.Label( 'Subject:' )
    self.subject_entry = gtk.Entry()
    # add components to vbox
    self.inner.add(title_label)
    self.inner.add(self.title_entry)
    self.inner.add(subject_label)
    self.inner.add(self.subject_entry)
    # add vbox to alignment
    self.add( self.inner )

if __name__ == "__main__":
  w = gtk.Window()
  w.add( CourseInfoView() )
  w.show_all()
  gtk.main()
