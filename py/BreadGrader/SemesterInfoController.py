##
# title: SemesterInfoController.py
# by: Brian Kim
# description: the controller that will display
#   information about a semester
#

from BreadInterface import Controller
from ui import SemesterInfoView
from model import BGModelController, Semester

class SemesterInfoController( Controller, SemesterInfoView.DataSource ):
  # 
  # SemesterInfoView DataSource
  #
  def season( self ):
    return self.semester.season()
  def year( self ):
    return self.semester.year()

  #
  # save method
  #
  def save( self ):
    # get the semester values from the ui
    season = self.view.get_season()
    year = int(self.view.get_year())
    # store the new values in the semester variable
    self.semester.season(season)
    self.semester.year(year)
    # save the changes into the db
    BGModelController.set_semester( self.semester )

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
  def __init__( self, semester, title="Semester Info"):
    # setup model
    BGModelController.init()
    self.semester = semester

    # setup breadinterface
    Controller.__init__( self, title=title, view=SemesterInfoView(self) )
    self.button_info_dict['tl'] = 'close without saving'
    self.button_info_dict['tr'] = 'save and close'
    
class SemesterAddController( SemesterInfoController ):
  def season( self ):
    return ''
  def year( self ):
    return ''

  def save( self ):
    # get the semester values from the ui
    season = self.view.get_season()
    year = int(self.view.get_year())
    # store the new values in the semester variable
    semester = Semester( season=season, year=year )
    # save the changes into the db
    BGModelController.add_semester( semester )

  def __init__( self ):
    SemesterInfoController.__init__( self, None, "Add Semester" )

if __name__ == "__main__":
  from breadinterface import App
  s = Semester( 2, "Spring", 2014 )
  app = App(appName='SemesterInfoController',root=SemesterAddController())
  app.start()
