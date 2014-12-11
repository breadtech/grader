##
# title: BreadGrader.py
# by: Brian Kim
# description: the top-level application class for BreadGrader
#

from breadinterface import App
from SemesterListController import SemesterListController

class BreadGrader( App ):
  def __init__( self ):
    App.__init__( self, appName='BreadGrader', root=SemesterListController() )

def main():
  app = BreadGrader()
  app.start()

if __name__ == "__main__":
  main()
