##
# title: CriteriaDBHelper.py
# by: Brian Kim
# description: a set of methods that define the CRUD methods
#   for a Criteria data type into a sqlite3 db
#

import sqlite3
from Course import Course
from Criteria import Criteria
import CourseDBHelper 

##
# constants
#
CRITERIA_TABLE_KEY = 'criteria'
CRITERIA_ID_KEY = 'id'
CRITERIA_COURSE_ID_KEY = 'course_id'
CRITERIA_TYPE_KEY = 'type'
CRITERIA_WEIGHT_KEY = 'weight'

##
# create
#
def create_criteria_table( db ):
  db.execute( '''CREATE TABLE criteria (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                       course_id INTEGER NOT NULL,
                                       type TEXT NOT NULL,
                                       weight INTEGER NOT NULL);''')
                                      
##
# update (add)
#
def add_criteria( db, criteria ):
  #
  # check for valid semester
  course_id = criteria.course().id()
  if course_id == -1:
    print 'WARNING: criteria ' + str(criteria) + ' does not have a valid course'

  # 
  # add criteria into db
  args = (course_id, criteria.type(), criteria.weight())
  c = db.cursor()
  c.execute( "INSERT INTO criteria (course_id,type,weight) VALUES (?,?,?);", args )
  db.commit()
  
  # return the course_id
  return c.lastrowid
  
##
# delete
#
def delete_criteria( db, id ):
  db.execute( "DELETE FROM criteria WHERE id=?;", (id,) )

##
# read
#
def get_criteria( db, id ):
  #
  # query db for the specified course
  c = db.cursor()
  c.execute( "SELECT * FROM criteria WHERE id=?;", (id,) )

  #
  # get a row from the cursor 
  rows = c.fetchone()
  if not rows == None: # the course exists
    # init a semester and course and return that
    course_id = int(rows[1])
    if course_id == -1:
      raise Exception('Criteria ' + rows[2] + ' does not have a valid course')
    course = CourseDBHelper.get_course( db, course_id )
    return Criteria( rows[0], course, rows[2], rows[3] )
  else:
    return None

##
# read (for a given course)
# 
def get_criteria_for_course( db, c_id ):
  c = db.cursor()
  c.execute( "SELECT * FROM criteria WHERE course_id=?;", (c_id,) )
  y=[]
  for row in c.fetchall():
    course_id = row[1]
    if course_id == -1:
      raise Exception('Criteria ' + rows[2] + ' does not have a valid course')
    y.append( Criteria(row[0], CourseDBHelper.get_semester( db, row[1] ),row[2],row[3]) )
  return y

##
# read (all)
#
def get_all_criterion( db ):
  c = db.cursor()
  c.execute( "SELECT * FROM criteria;" )
  y=[]
  for row in c.fetchall():
    course_id = row[1]
    if course_id == -1:
      raise Exception('Criteria ' + rows[2] + ' does not have a valid course')
    y.append( Criteria(row[0], CourseDBHelper.get_semester( db, row[1] ),row[2],row[3]) )
  return y

##
# update
#
def set_criteria( db, criteria ):
  args = (criteria.course().id(), criteria.type(), criteria.weight())
  c = db.cursor()
  c.execute( "UPDATE criteria SET course_id=?,type=?,weight=? WHERE id=?;", args )
  db.commit()
  return c.rowcount
  
