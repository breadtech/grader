##
# title: Semester.py
# by: Brian Kim
# description: a class that defines an academic semester 
#

class Semester:
  def __init__( self, id, season, year ):
    self._id = id
    self._season = season
    self._year = year
  
  def id( self, x=None ):
    if x == None:
      return self._id
    else:
      self._id = x

  def season( self, x=None ):
    if x == None:
      return self._season
    else:
      self._season = x

  def year( self, x=None ):
    if x == None:
      return self._year
    else:
      self._year = x
