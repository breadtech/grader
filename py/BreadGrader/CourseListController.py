##
# title: CourseListController.py
# by: Brian Kim
# description: the controller that displays the list of courses
#

from breadinterface import Controller, App
from model import BGModelController
from ui import CourseListView
from SemesterInfoController import *
from CriteriaListController import *

class CourseListController( Controller, CourseListView.Delegate, CourseListView.DataSource ):
  #
  # CourseListView Delegate
  # 
  def n_courses( self ):
    return len(self.course_list)
  def course_clicked_at( self, index ):
    self.nav.push( CriteriaListController( self.course_list[index] ) )

  #
  # CourseListView DataSource
  # 
  def title_at_index( self, i ):
    return self.course_list[i].title()

  def grade_at_index( self, i ):
    return str(BGModelController.course_avg(self.course_list[i]))

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
    self.nav.push( SemesterInfoController( self.semester ))
  
  #
  # remove
  def bl_label( self ):
    return '-'
  def bl_clicked( self,x ):
    i = self.view.selected_index()
    BGModelController.delete_course( self.course_list[i] )
    self.update()

  #
  # overall avg
  def bm_label( self ):
    msg = "semester avg: "
    msg += str(BGModelController.semester_avg(self.semester))
    return msg

  #
  # add
  def br_label( self ):
    return '+'
  def br_clicked( self,x ):
    self.nav.push( CourseAddController() )

  # 
  # BreadInterface Lifecycle
  #
  def update( self ):
    self.course_list = BGModelController.get_courses_for_semester(self.semester)
    Controller.update(self)
    
  def __init__( self, semester ):
    # init model
    self.semester = semester
    BGModelController.init()
    self.course_list = BGModelController.get_courses_for_semester(self.semester)
    # init bi
    Controller.__init__( self, title="Course List", view=CourseListView(self,self) )
    self.button_info_dict['tl'] = 'go back to the Semester list'
    self.button_info_dict['tr'] = 'view the Semester information'
    self.button_info_dict['bl'] = 'delete currently selected course'
    self.button_info_dict['bm'] = 'None'
    self.button_info_dict['br'] = 'add a course'

if __name__ == '__main__':
  print 'this controller cannot be the main!'
