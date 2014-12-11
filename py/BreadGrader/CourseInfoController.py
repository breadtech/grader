##
# title: CourseInfoController.py
# by: Brian Kim
# description: the controller that will display
#   information about a course
#

from breadinterface import Controller
from ui import CourseInfoView
from model import BGModelController, Course

class CourseInfoController( Controller, CourseInfoView.DataSource ):
  # 
  # CourseInfoView DataSource
  #
  def the_title( self ):
    return self.course.title()
  def subject( self ):
    return self.course.subject()

  #
  # save method
  #
  def save( self ):
    # get the course values from the ui
    title = self.view.get_title()
    subject = int(self.view.get_subject())
    # store the new values in the course variable
    self.course.title(title)
    self.course.subject(subject)
    # save the changes into the db
    BGModelController.set_course( self.course )

  #
  # breadinterface button layout
  # 

  #
  # cancel
  def tl_label( self ):
    return 'X'

  def tl_clicked( self,w ):
    self.nav.pop()

  #
  # save and close
  def tr_label( self ):
    return unichr(0x2713)

  def tr_clicked( self,w ):
    self.save()
    self.nav.pop()

  # 
  # breadinterface lifecycle
  #

  #
  # constructor
  def __init__( self, course, title="Course Info"):
    # setup model
    BGModelController.init()
    self.course = course

    # setup breadinterface
    Controller.__init__( self, title=title, view=CourseInfoView(self) )
    self.button_info_dict['tl'] = 'close without saving'
    self.button_info_dict['tr'] = 'save and close'
    
class CourseAddController( CourseInfoController ):
  def title( self ):
    return ''
  def subject( self ):
    return ''

  def save( self ):
    # get the course values from the ui
    title = self.view.get_title()
    subject = self.view.get_subject()
    # store the new values in the course variable
    course = Course( title=title, subject=subject )
    # save the changes into the db
    BGModelController.add_course( course )

  def __init__( self ):
    CourseInfoController.__init__( self, None, "Add Course" )

if __name__ == "__main__":
  print 'this controller may not be the root user'
