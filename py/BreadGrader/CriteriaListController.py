##
# title: CriteriaListController.py
# by: Brian Kim
# description: the controller that displays the list of criterias
#

from breadinterface import Controller
from model import BGModelController
from ui import CriteriaListView
from CourseInfoController import *
from AssignmentListController import *

class CriteriaListController( Controller, CriteriaListView.Delegate, CriteriaListView.DataSource ):
  #
  # CriteriaListView Delegate
  # 
  def n_criterias( self ):
    return len(self.criteria_list)
  def criteria_clicked_at( self, index ):
    self.nav.push( AssignmentListController( self.criteria_list[index] ) )

  #
  # CriteriaListView DataSource
  # 
  def type_at_index( self, i ):
    return self.criteria_list[i].type()

  def weight_at_index( self, i ):
    return self.criteria_list[i].weight()

  def avg_at_index( self, i ):
    return str(BGModelController.criteria_avg(self.criteria_list[i]))

  #
  # utility methods
  # 


  #
  # BreadInterface Button Layout
  #

  #
  # help
  def tl_label( self ):
    return unichr(0x2190)
  def tl_clicked( self,x ):
    self.nav.pop()

  #
  # settings
  def tr_label( self ):
    return 'i'
  def tr_clicked( self,x ):
    self.nav.push( CourseInfoController( self.course ))
  
  #
  # remove
  def bl_label( self ):
    return '-'
  def bl_clicked( self,x ):
    i = self.view.selected_index()
    BGModelController.delete_criteria( self.criteria_list[i] )
    self.update()

  #
  # overall avg
  def bm_label( self ):
    msg = "course avg: "
    msg += str(BGModelController.course_avg(self.course))
    return msg

  #
  # add
  def br_label( self ):
    return '+'
  def br_clicked( self,x ):
    self.nav.push( CriteriaAddController(self.course) )

  # 
  # BreadInterface Lifecycle
  #
  def update( self ):
    self.criteria_list = BGModelController.get_criterion_for_course(self.course)
    Controller.update(self)
    
  def __init__( self, course ):
    # init model
    self.course = course
    BGModelController.init()
    self.criteria_list = BGModelController.get_criterion_for_course(self.course)
    # init bi
    Controller.__init__( self, title="Criteria List", view=CriteriaListView(self,self) )
    self.button_info_dict['tl'] = 'go back to the Course list'
    self.button_info_dict['tr'] = 'view the Course information'
    self.button_info_dict['bl'] = 'delete currently selected criteria'
    self.button_info_dict['bm'] = 'None'
    self.button_info_dict['br'] = 'add a criteria'

if __name__ == '__main__':
  print 'this controller cannot be the main!'
