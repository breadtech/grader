##
# title: Grader.py
# by: Brian Kim
# description: a utility module that can perform grading functions
#

def avg( grades ):
  """
  computes the average of a list of Grade objects
  """
  rcv = 0
  max = 0
  for grade in grades:
    if grade.is_graded():
      rcv += grade.received()
      max += grade.max()
  return Grade(max,rcv)

def avg( grades, weights ):
  """
  computes the weighted average of a list of Grade objects
    requirements: 
    - size of Grade and weight list must be the same
    - sum of weights equal 1.0
  """
  if len(grades) != len(weights):
    raise Exception( "size of Grade list and weight list do not match" )
  if sum(weights) > 1.0001 or sum(weights) < 0.9999:
    raise Exception( "sum of weights be 1.0" )
  rcv = 0
  max = 0
  n = len(grades)
  for i in range(n):
    grade = grades[i]
    if grade.is_graded():
      weight = weights[i]
      rcv += grade.received()*weight
      max += grade.max()*weight
  return Grade(max,rcv)

