##
# title: SemesterDBHelper.py
# by: Brian Kim
# description: a set of methods that help manage the interactions
#   of adding, deleting, and editing semesters to/from a 
#   sqlite database
#

import sqlite3
from Semester import Semester

SEMESTER_TABLE_KEY = 'semesters'
SEMESTER_ID_KEY = 'id'
SEMESTER_SEASON_KEY = 'season'
SEMESTER_YEAR_KEY = 'year'

def create_semester_table( db ):
  db.execute( '''CREATE TABLE IF NOT EXISTS semesters (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                         season TEXT NOT NULL,
                                         year INTEGER NOT NULL);''')
  db.commit()

def add_semester( db, semester ):
  args = (semester.season(), semester.year())
  db.execute( "INSERT INTO semesters ( season, year ) VALUES (?,?)", args )
  db.commit()
  
def delete_semester( db, id ):
  db.execute( "DELETE FROM semesters WHERE id=?", (id,) )
  db.commit()

def get_semester( db, id ):
  c = db.cursor()
  c.execute( "SELECT * FROM semesters WHERE id=?", (id,) )
  rows = c.fetchone()
  if not rows == None:
    return Semester( rows[0], rows[1], rows[2] )
  else:
    return None

def get_all_semesters( db, season="fall", year=2014 ):
  c = db.cursor()
  c.execute( "SELECT * FROM semesters" )
  return [ Semester(row[0],row[1],row[2]) for row in c.fetchall() ]

def set_semester( db, semester ):
  c = db.cursor()
  c.execute( "UPDATE semesters SET season=?,year=? WHERE id=?", (semester.season(), semester.year(), semester.id() ) )
  db.commit()
  return c.rowcount
