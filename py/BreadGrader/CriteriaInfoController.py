##
# title: CriteriaInfoController.py
# by: Brian Kim
# description: the controller that will display
#   information about a criteria
#

from BreadInterface import Controller
from ui import CriteriaInfoView
from model import BGModelController, Criteria

class CriteriaInfoController( Controller, CriteriaInfoView.DataSource ):
  # 
  # CriteriaInfoView DataSource
  #
  def type( self ):
    return self.criteria.type()
  def weight( self ):
    return self.criteria.weight()

  #
  # save method
  #
  def save( self ):
    # get the criteria values from the ui
    type = self.view.get_type()
    weight = int(self.view.get_weight())
    # store the new values in the criteria variable
    self.criteria.type(type)
    self.criteria.weight(weight)
    # save the changes into the db
    BGModelController.set_criteria( self.criteria )

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
  def __init__( self, criteria, title="Criteria Info"):
    # setup model
    BGModelController.init()
    self.criteria = criteria

    # setup breadinterface
    Controller.__init__( self, title=title, view=CriteriaInfoView(self) )
    self.button_info_dict['tl'] = 'close without saving'
    self.button_info_dict['tr'] = 'save and close'
    
class CriteriaAddController( CriteriaInfoController ):
  def type( self ):
    return ''
  def weight( self ):
    return ''

  def save( self ):
    # get the criteria values from the ui
    type = self.view.get_type()
    weight = self.view.get_weight()
    # store the new values in the criteria variable
    criteria = Criteria( -1, self.course, type, weight )
    # save the changes into the db
    BGModelController.add_criteria( criteria )

  def __init__( self, course ):
    self.course = course
    CriteriaInfoController.__init__( self, None, "Add Criteria" )

if __name__ == "__main__":
  print 'this controller may not be the root user'
