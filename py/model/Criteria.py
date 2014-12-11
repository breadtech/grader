#
# title: Criteria.py
# by: Brian Kim
# description: a 
#

from Course import Course

class Criteria:
  def __init__( self, _id=-1, course=Course(), 
                              type="Test", 
                              weight=20 ):
    self._id = _id
    self._course = course
    self._type = type
    self._weight = weight

  def id( self, x=None ):
    if x == None:
      return self._id
    else:
      self._id = x

  def course( self, x=None ):
    if x == None:
      return self._course
    else:
      self._course = x

  def type( self, x=None ):
    if x == None:
      return self._type
    else:
      self._type = x

  def weight( self, x=None ):
    if x == None:
      return self._weight
    else:
      self._weight = x

