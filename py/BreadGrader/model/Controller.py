##
# title: BreadGrader Model Controller
# by: Brian Kim
# description: the class that manages all the user
#   interactions of the data with the database
#

import sqlite3

#
# classes
from Semester import Semester
from Course import Course
from Criteria import Criteria
from Assignment import Assignment
from Grade import Grade

#
# utilities
import Grader

#
# db helper scripts
import SemesterDBHelper 
import CourseDBHelper 
import CriteriaDBHelper 
import AssignmentDBHelper 

db = None

#====================================
# setup methods
#====================================

def init():
  """ 
  initializes the database
  """
  global db 
  # get the home path
  from os.path import expanduser
  home_dir = expanduser("~")
                              
  # create the settings file name
  fname = ".BreadGrader.db"
  db_path = home_dir + "/" + fname

  # connect to db
  db = sqlite3.connect(db_path)

  # create tables (if they don't exist)
  SemesterDBHelper.create_semester_table(db)
  CourseDBHelper.create_course_table(db)
  CriteriaDBHelper.create_criteria_table(db)
  AssignmentDBHelper.create_assignment_table(db)

def cleanup():
  """ 
  closes the database 
  """
  db.close()

#====================================
# database crud methods
#====================================

#
# semester
#

def add_semester( semester ):
  return SemesterDBHelper.add_semester(db,semester)

def get_all_semesters():
  return SemesterDBHelper.get_all_semesters(db)

def set_semester( semester ):
  return SemesterDBHelper.set_semester(db,semester)

def delete_semester( semester ):
  return SemesterDBHelper.delete_semester(db,semester.id())

#
# course
#

def add_course( course ):
  return CourseDBHelper.add_course(db,course)

def get_all_courses():
  return CourseDBHelper.get_all_courses(db)

def get_courses_for_semester( semester ):
  return CourseDBHelper.get_courses_for_semester(db,semester.id())

def set_course( course ):
  return CourseDBHelper.set_course(db,course)

def delete_course( course ):
  return CourseDBHelper.delete_course(db,course.id())

#
# criteria
#

def add_criteria( cr ):
  return CriteriaDBHelper.add_criteria(db,cr)

def get_criterion_for_course( course ):
  return CriteriaDBHelper.get_criterion_for_course(db,course.id())
 
def set_criteria( cr ):
  return CriteriaDBHelper.set_criteria(db,cr)

def delete_criteria( cr ):
  return CriteriaDBHelper.delete_criteria(db,cr.id())

#
# assignment
#

def add_assignment( assignment ):
  return AssignmentDBHelper.add_assignment(db,assignment)

def get_assignments_for_criteria( criteria ):
  return AssignmentDBHelper.get_assignments_for_criteria(db,criteria.id())

def set_assignment( assignment ):
  return AssignmentDBHelper.set_assignment(db,assignment)

def delete_assignment( assignment ):
  return CriteriaDBHelper.delete_assignment(db,assignment.id())

"""
ZZ: not yet implemented
def get_assignments_for_course( course ):
  return AssignmentDBHelper.get_assignments_for_course(db,course.id())

def get_all_ungraded_assignments():
  return None
"""

#==================================================
# grading methods
#==================================================

def cumulative_avg():
  # get all the semesters
  semesters = get_all_semesters()
  # get all the avg semester grades
  avgs = []
  for semester in semesters:
    avgs.append( semester_avg( semester ))
  return Grader.avg(avgs)
  
def semester_avg( semester ):
  # get all the courses
  courses = get_courses_for_semester( semester )
  # get all the avg course grades
  avgs = []
  for course in courses:
    avgs.append( course_avg(course) )
  return Grader.avg(avgs)

def course_avg( course ):
  # get all the criterion
  criterion = get_criterion_for_course(course)
  # get all the avg criteria grades and weights
  avgs = []
  weights = []
  for criteria in criterion:
    avgs.append( criteria_avg( criteria ) )
    weights.append( criteria.weight() )
  return Grader.weighted_avg(avgs,weights)

def criteria_avg( criteria ):
  # get all the assignments for a given criteria
  assignments = get_assignments_for_criteria(criteria)
  # get all the grade objects within the assignments
  grades = []
  for assignment in assignments:
    grades.append( assignment.grade() )
  # compute the average and return
  return Grader.avg(grades)

