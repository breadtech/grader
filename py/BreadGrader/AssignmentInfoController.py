##
# title: AssignmentInfoController.py
# by: Brian Kim
# description: the controller that will display
#   information about a assignment
#

from breadinterface import Controller
from ui import AssignmentInfoView
from model import BGModelController, Assignment, Grade
import time

class AssignmentInfoController( Controller, AssignmentInfoView.DataSource ):
  # 
  # AssignmentInfoView DataSource
  #
  def type( self ):
    return self.assignment.criteria().type()
  def index( self ):
    return self.assignment.index()
  def name( self ):
    return self.assignment.name()
  def due( self ):
    return self.assignment.due()
  def max( self ):
    return self.assignment.grade().max() 
  def received( self ):
    return self.assignment.grade().received()
  def notes( self ):
    return self.assignment.notes()

  #
  # save method
  #
  def save( self ):
    # get the assignment values from the ui
    index = self.view.get_index()
    name = self.view.get_name()
    due = float(self.view.get_due())
    max = float(self.view.get_max())
    rcv = float(self.view.get_received())
    notes = self.view.get_notes()

    # store the new values in the assignment variable
    self.assignment.index(index)
    self.assignment.name(name)
    self.assignment.due(due)
    self.assignment.notes(notes)
    self.assignment.grade(Grade(max,rcv))

    # save the changes into the db
    BGModelController.set_assignment( self.assignment )

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
  def __init__( self, assignment, title="Assignment Info"):
    # setup model
    BGModelController.init()
    self.assignment = assignment

    # setup breadinterface
    Controller.__init__( self, title=title, view=AssignmentInfoView(self) )
    self.button_info_dict['tl'] = 'close without saving'
    self.button_info_dict['tr'] = 'save and close'
    
class AssignmentAddController( AssignmentInfoController ):

  #
  # redefinition of datasoure
  # 
  def type( self ):
    return self.criteria.type()
  def index( self ):
    return self.i
  def name( self ):
    return ''
  def due( self ):
    return time.time()
  def max( self ):
    return 100
  def received( self ):
    return 100 
  def notes( self ):
    return ''

  def save( self ):
    # get the assignment values from the ui
    index = self.view.get_index()
    name = self.view.get_name()
    due = float(self.view.get_due())
    max = float(self.view.get_max())
    rcv = float(self.view.get_received())
    grade = Grade(max,rcv)
    notes = self.view.get_notes()

    # store the new values in the assignment variable
    assignment = Assignment(-1,self.criteria,index,name,due,grade,notes)

    # save the changes into the db
    BGModelController.add_assignment( assignment )

  def __init__( self, criteria, starting_index ):
    self.criteria = criteria
    self.i = starting_index
    AssignmentInfoController.__init__( self, None, "Add Assignment" )

if __name__ == "__main__":
  print 'this controller may not be the root user'
