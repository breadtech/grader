#
# title: Course.py
# by: Brian Kim
# description: a 
#

from Semester import Semester

class Course:
  def __init__( self, _id=-1, semester=Semester(), 
                              title="Calculus", 
                              subject ="Math" ):
    self._id = _id
    self._semester = semester
    self._title = title
    self._subject = subject
  
  def id( self, x=None ):
    if x == None:
      return self._id
    else:
      self._id = x

  def semester( self, x=None ):
    if x == None:
      return self._semester
    else:
      self._semester = x

  def title( self, x=None ):
    if x == None:
      return self._title
    else:
      self._title = x

  def subject( self, x=None ):
    if x == None:
      return self._subject
    else:
      self._subject = x

