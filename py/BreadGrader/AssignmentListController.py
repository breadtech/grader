##
# title: AssignmentListController.py
# by: Brian Kim
# description: the controller that displays the list of assignments
#

from breadinterface import Controller
from model import BGModelController
from ui import AssignmentListView
from AssignmentInfoController import *
from CriteriaInfoController import *

class AssignmentListController( Controller, AssignmentListView.Delegate, AssignmentListView.DataSource ):
  #
  # AssignmentListView Delegate
  # 
  def n_assignments( self ):
    return len(self.assignment_list)
  def assignment_clicked_at( self, index ):
    self.nav.push( AssignmentInfoController( self.assignment_list[index] ) )

  #
  # AssignmentListView DataSource
  # 
  def index_at_index( self, i ):
    return self.assignment_list[i].index()

  def name_at_index( self, i ):
    return self.assignment_list[i].name()

  def grade_at_index( self, i ):
    return str(self.assignment_list[i].grade())

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
    self.nav.push( CriteriaInfoController( self.criteria ))
  
  #
  # remove
  def bl_label( self ):
    return '-'
  def bl_clicked( self,x ):
    i = self.view.selected_index()
    BGModelController.delete_assignment( self.assignment_list[i] )
    self.update()

  #
  # overall avg
  def bm_label( self ):
    msg = "criteria avg: "
    msg += str(BGModelController.criteria_avg(self.criteria))
    return msg

  #
  # add
  def br_label( self ):
    return '+'
  def br_clicked( self,x ):
    self.nav.push( AssignmentAddController( self.criteria, len(self.assignment_list)+1 ) )

  # 
  # BreadInterface Lifecycle
  #
  def update( self ):
    self.assignment_list = BGModelController.get_assignments_for_criteria(self.criteria)
    Controller.update(self)
    
  def __init__( self, criteria ):
    # init model
    self.criteria = criteria
    BGModelController.init()
    self.assignment_list = BGModelController.get_assignments_for_criteria(self.criteria)
    # init bi
    Controller.__init__( self, title="Assignment List", view=AssignmentListView(self,self) )
    self.button_info_dict['tl'] = 'go back to the Criteria list'
    self.button_info_dict['tr'] = 'view the Criteria information'
    self.button_info_dict['bl'] = 'delete currently selected assignment'
    self.button_info_dict['bm'] = 'None'
    self.button_info_dict['br'] = 'add a assignment'

if __name__ == '__main__':
  print 'this controller cannot be the main!'
