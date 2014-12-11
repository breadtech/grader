##
# title: AssignmentDBHelper.py
# by: Brian Kim
# description: a set of methods that help manage the interactions
#   of adding, deleting, and editing assignments to/from a 
#   sqlite database
#

import sqlite3
from Course import *
from Criteria import *
from Assignment import *
import CriteriaDBHelper

ASSIGNMENT_TABLE_KEY = 'assignments'
ASSIGNMENT_ID_KEY = 'id'
ASSIGNMENT_CRITERIA_ID_KEY = 'criteria'
ASSIGNMENT_INDEX_KEY = 'index'
ASSIGNMENT_NAME_KEY = 'name'
ASSIGNMENT_DUE_KEY = 'due'
ASSIGNMENT_RECEIVED_KEY = 'received'
ASSIGNMENT_MAX_KEY = 'max'
ASSIGNMENT_NOTES_KEY = 'notes'

def create_assignment_table( db ):
  db.execute( '''CREATE TABLE IF NOT EXISTS assignments (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
                                           criteria_id INTEGER NOT NULL, 
                                           i INTEGER NOT NULL, 
                                           name TEXT NOT NULL, 
                                           due REAL NOT NULL, 
                                           received REAL NOT NULL, max REAL NOT NULL, 
                                           notes TEXT NOT NULL);''')
  db.commit()

def add_assignment( db, assignment ):
  #
  # check for valid criteria
  criteria_id = assignment.criteria().id()
  if criteria_id == -1:
    print 'WARNING: assignment '+str(assignment)+' does not have a valid course'

  #
  # add assignment into db
  args = (criteria_id, assignment.index(), assignment.name(), 
          assignment.due(), assignment.grade().received(), assignment.grade().max(), assignment.notes())
  c = db.cursor()
  c.execute( "INSERT INTO assignments ( criteria_id, i, name, due, received, max, notes ) VALUES (?,?,?,?,?,?,?)", args )
  db.commit()

  return c.lastrowid
  
def delete_assignment( db, id ):
  db.execute( "DELETE FROM assignments WHERE id=?", (id,) )
  db.commit()

def get_assignment( db, id ):
  #
  # query db for specified assignment
  c = db.cursor()
  c.execute( "SELECT * FROM assignments WHERE id=?", (id,) )

  #
  # get a row from the cursor
  rows = c.fetchone()
  if not rows == None:
    # get the criteria if it exists
    criteria_id = rows[1]
    if criteria_id == -1:
      raise Exception('Assignment ' +rows[3]+ ' does not have a valid criteria')
    criteria = CriteriaDBHelper.get_criteria( db, criteria_id )
    return Assignment( rows[0], criteria, rows[2], rows[3], rows[4], Grade(rows[6], rows[5]), rows[7] )
  else:
    return None

def get_assignments_for_criteria( db, cr_id ):
  c = db.cursor()
  c.execute( "SELECT * FROM assignments WHERE criteria_id=?;", (cr_id,) )
  y=[]
  for rows in c.fetchall():
    criteria_id = rows[1]
    if criteria_id == -1: 
      raise Exception('Assignment ' + rows[2] + ' does not have a valid criteria')
    criteria = CriteriaDBHelper.get_criteria( db, criteria_id )
    y.append( Assignment( rows[0], criteria, rows[2], rows[3], rows[4], Grade(rows[6], rows[5]), rows[7] ) )
  return y

"""
ZZ: bugged out...
def get_assignments_for_course( db, c_id ):
  c = db.cursor()
  c.execute( "SELECT * FROM assignments WHERE course_id=?;", (c_id,) )
  y=[]
  for rows in c.fetchall():
    criteria_id = rows[1]
    if criteria_id == -1: 
      raise Exception('Assignment ' + rows[2] + ' does not have a valid criteria')
    criteria = CriteriaDBHelper.get_criteria( db, criteria_id )
    y.append( Assignment( rows[0], criteria, rows[2], rows[3], rows[4], Grade(rows[6], rows[5]), rows[7] ) )
  return y
"""

def get_all_assignments( db ):
  c = db.cursor()
  c.execute( "SELECT * FROM assignments;" )
  y=[]
  for rows in c.fetchall():
    criteria_id = rows[1]
    if criteria_id == -1: 
      raise Exception('Assignment ' + rows[2] + ' does not have a valid criteria')
    criteria = CriteriaDBHelper.get_criteria( db, criteria_id )
    y.append( Assignment( rows[0], criteria, rows[2], rows[3], rows[4], Grade(rows[6], rows[5]), rows[7] ) )
  return y

def set_assignment( db, assignment ):
  args = (assignment.criteria().id(), assignment.index(), assignment.name(), assignment.due(), 
          assignment.grade().received(), assignment.grade().max(), assignment.notes(), assignment.id())
  c = db.cursor()
  c.execute( "UPDATE assignments SET criteria_id=?,i=?,name=?,due=?,received=?,max=?,notes=? WHERE id=?", args )
  db.commit()
  return c.rowcount
