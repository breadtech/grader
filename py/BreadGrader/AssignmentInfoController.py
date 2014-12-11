from breadinterface import * 
from model import Assignment
import gtk
from datetime import date
import time

class AssignmentInfoController(Controller):

  class AssignmentInfoView( gtk.Table, lifecycle):
         
    def __init__( self, assignment=None, edit=True ):
      gtk.Table.__init__( self, 8, 2, True )
      self.type_entry = gtk.Entry()
      self.index_entry = gtk.Entry()
      self.name_entry = gtk.Entry()
      self.due_entry = gtk.Entry()
      self.max_entry = gtk.Entry()
      self.received_entry = gtk.Entry()
      self.notes_entry = gtk.Entry()
      self.type_entry.set_editable( False )
      
      if assignment:
        self.type_entry.set_text( str(assignment.type()))
        self.index_entry.set_text( str(assignment.index()))
        self.name_entry.set_text( str(assignment.name()))
        self.due_entry.set_text( str(assignment.due()))
        self.notes_entry.set_text( str(assignment.notes()))
        self.received_entry.set_text( str(assignment.grade().received()))
        self.max_entry.set_text( str(assignment.grade().max()))
      
      type_label = gtk.Label("type:")
      index_label = gtk.Label("index:")
      name_label = gtk.Label("name:")
      due_label = gtk.Label("due date:")
      max_label = gtk.Label("max:")
      received_label = gtk.Label("received:")
      notes_label = gtk.Label("notes:")

      #fill table with labels
      self.attach(type_label,0,1,0,1)
      self.attach(self.type_entry,1,2,0,1)
      self.attach(index_label,0,1,1,2)
      self.attach(self.index_entry,1,2,1,2)
      self.attach(name_label,0,1,2,3)
      self.attach(self.name_entry,1,2,2,3)
      self.attach(due_label,0,1,3,4)
      self.attach(self.due_entry,1,2,3,4)
      self.attach(max_label,0,1,4,5)
      self.attach(self.max_entry,1,2,4,5)
      self.attach(received_label,0,1,5,6)
      self.attach(self.received_entry,1,2,5,6)
      self.attach(notes_label,0,1,6,7)
      self.attach(self.notes_entry,1,2,6,7)

      self.edit( edit )
      self.update()
      
    def edit( self, x=None ):
      if x == None:
        return self._edit
      else:
        self.type_entry.set_editable( x )
        self.index_entry.set_editable( x )
        self.name_entry.set_editable( x )
        self.due_entry.set_editable( x )
        self.max_entry.set_editable( x )
        self.received_entry.set_editable( x )
        self.notes_entry.set_editable( x )
        self._edit = x

    def update( self ):
      pass
      
  def __init__( self, assignment=None, edit=True ):
    self._edit = False
    self.assignment = None

    Controller.__init__( self, view=AssignmentInfoController.AssignmentInfoView(assignment) )
    
    # if an assignment is provided, the controller should be in view mode
    if assignment:
      self.assignment = assignment
      edit = False

    # toggle edit mode for the components
    self.edit( edit )
    
  def edit( self, x=None ):
    if x == None:
      return self._edit
    else:
      self._edit = x
      self.view.edit( x )
      self.update()

  #
  # the breadinterface button layout protocol
  #
  
  #
  # top-left
  def tl_label(self):
    return "X";  

  def tl_clicked( self, widget ):
    if self.edit():
      self.edit( False )
    else:
      self.nav.pop()

  #
  # top-right
  def tr_label(self):
    y = unichr(10003) if self.edit() else unichr(0x270D) 
    return y

  def tr_clicked( self, widget ):
    self.edit( not self.edit() )
    
  #
  # top-middle
  def tm_label(self):
    return "Assignment Info"
  
  #
  # bottom-middle
  def bm_label(self):
    g = str(self.assignment.grade()) if self.assignment else "not graded"
    y = unichr(10003)+"to save, X to cancel" if self.edit() else "grade: "+g
    return y

if __name__ == "__main__":
  app = App(AssignmentInfoController(Assignment(grade=Grade(10, 8))))
  app.start()
