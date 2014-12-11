##
# title: CourseDBHelper.py
# by: Brian Kim
# description: a set of methods that help manage the interactions
#   of adding, deleting, and editing courses to/from a 
#   sqlite database
#

import sqlite3
from Semester import Semester
from Course import Course
import SemesterDBHelper 

##
# constants
#
COURSE_TABLE_KEY = 'courses'
COURSE_ID_KEY = 'id'
COURSE_SEMESTER_ID_KEY = 'semester_id'
COURSE_TITLE_KEY = 'title'
COURSE_SUBJECT_KEY = 'subject'

##
# create
#
def create_course_table( db ):
  db.execute( '''CREATE TABLE courses (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                       semester_id INTEGER NOT NULL,
                                       title TEXT NOT NULL,
                                       subject TEXT NOT NULL);''')
                                      
##
# update (add)
#
def add_course( db, course ):
  #
  # check for valid semester
  semester_id = course.semester().id()
  if semester_id == -1:
    print 'WARNING: course ' + str(course) + ' does not have a valid semester'

  # 
  # query db for course
  args = (course.semester().id(), course.title(), course.subject())
  c = db.cursor()
  c.execute( "INSERT INTO courses ( semester_id, title, subject ) VALUES (?,?,?);", args )
  db.commit()
  
  # return the course_id
  return c.lastrowid
  
##
# delete
#
def delete_course( db, id ):
  db.execute( "DELETE FROM courses WHERE id=?;", (id,) )

##
# read
#
def get_course( db, id ):
  #
  # query db for the specified course
  c = db.cursor()
  c.execute( "SELECT * FROM courses WHERE id=?;", (id,) )

  #
  # get a row from the cursor 
  rows = c.fetchone()
  if not rows == None: # the course exists
    # init a semester and course and return that
    semester_id = int(rows[1])
    if semester_id == -1:
      raise Exception('Course ' + row[2] + ' does not have a semester')
    semester = SemesterDBHelper.get_semester( db, semester_id )
    return Course( rows[0], semester, rows[2], rows[3] )
  else:
    return None

##
# read (all)
#
def get_all_courses( db ):
  c = db.cursor()
  c.execute( "SELECT * FROM courses;" )
  y=[]
  for row in c.fetchall():
    semester_id = int(row[1])
    if semester_id == -1:
      raise Exception('Course ' + row[2] + ' does not have a semester')
    y.append( Course( row[0], SemesterDBHelper.get_semester( db, semester_id ), row[2], row[3] ) )
  return y

##
# update
#
def set_course( db, course ):
  args = (course.semester().id(), course.title(), course.subject(),course.id())
  c = db.cursor()
  c.execute( "UPDATE courses SET semester_id=?,title=?,subject=? WHERE id=?;", args )
  db.commit()
  return c.rowcount
  
