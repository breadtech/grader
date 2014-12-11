##
# title: SemesterListController.py
# by: Brian Kim
# description: the controller that displays the list of semesters
#

from breadinterface import Controller, App
from model import BGModelController
from ui import SemesterListView
from SemesterInfoController import *

class SemesterListController( Controller, SemesterListView.Delegate, SemesterListView.DataSource ):
  #
  # SemesterListView Delegate
  # 
  def n_semesters( self ):
    return len(self.semester_list)
  def semester_clicked_at( self, index ):
    print 'semester ' + str(index) + ' clicked'
    pass # push course list controller

  #
  # SemesterListView DataSource
  # 
  def season_at_index( self, i ):
    return self.semester_list[i].season()

  def year_at_index( self, i ):
    return self.semester_list[i].year()

  #
  # utility methods
  # 


  #
  # BreadInterface Button Layout
  #

  #
  # help
  def tl_label( self ):
    return "?"
  def tl_clicked( self,x ):
    print 'BreadGrader v0.9 by BreadTech' 

  #
  # settings
  def tr_label( self ):
    return unichr(0x2699)
  def tr_clicked( self,x ):
    print 'Settings not yet implemented'
  
  #
  # remove
  def bl_label( self ):
    return '-'
  def bl_clicked( self,x ):
    i = self.view.selected_index()
    BGModelController.delete_semester( self.semester_list[i] )
    self.update()

  #
  # add
  def br_label( self ):
    return '+'
  def br_clicked( self,x ):
    self.nav.push( SemesterAddController() )

  # 
  # BreadInterface Lifecycle
  #
  def update( self ):
    self.semester_list = BGModelController.get_all_semesters()
    Controller.update(self)
    
  def __init__( self ):
    # init model
    BGModelController.init()
    self.semester_list = BGModelController.get_all_semesters()
    # init bi
    Controller.__init__( self, title="Semester List", view=SemesterListView(self,self) )
    self.button_info_dict['tl'] = 'about this app'
    self.button_info_dict['tr'] = 'open settings'
    self.button_info_dict['bl'] = 'delete currently selected semester'
    self.button_info_dict['bm'] = 'None'
    self.button_info_dict['br'] = 'add a semester'

if __name__ == '__main__':
  app = App( appName='BreadGrader', root=SemesterListController() )
  app.start()
