#define Grade class

class Grade:
  def __init__ (self, mx=100, received=-1):
    self._max = mx
    self._received = received

  def max( self ):
    return self._max
    
  def received( self ):
    return self._received
    
  def grade(self):
    return self._received/self._max * 100 if self._max > 0 and self.is_graded() else -1
   
  def is_graded( self ):
    return not self._received == -1

  def __str__( self ):
    return str(round( self.grade(), 2 )) + "%" if self.is_graded else "not graded"
