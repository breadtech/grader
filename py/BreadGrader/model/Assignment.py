#
# title: Assignment.py
# by: Brian Kim
# description: a task that is given to a student to complete within a
#   certain deadline
#

import time
from Grade import Grade
from Criteria import Criteria

class Assignment:

  def __init__( self, id=-1, criteria=Criteria(), index=0, name="the beginning", due=time.time(), grade=Grade(), notes="this is the first assignment" ):
    self._id = id
    self._criteria = criteria
    self._index = index
    self._name = name
    self._due = due
    self._grade = grade
    self._notes = notes
    
  def id( self, x=None ):
    if x == None:
      return self._id
    else:
      self._id=x

  def due(self,x=None):
    if x == None:
      return  self._due
    else:
      self._due=x

  def criteria(self,x=None):
    if x == None:
      return  self._criteria
    else:
      self._criteria=x
      
  def index(self,x=None):
    if x == None:
      return  self._index
    else:
      self._index=x
      
  def grade(self,x=None):
    if x == None:
      return  self._grade
    else:
      self._grade=x
      
  def name(self,x=None):
    if x == None:
      return  self._name
    else:
      self._name=x
      
  def notes(self,x=None):
    if x == None:
      return  self._notes
    else:
      self._comments=x
      
