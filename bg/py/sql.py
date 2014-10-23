#sql.py
#Michael Fiorelli
#Tables for breadgrader

import sqlite3
conn = sqlite3.connect('grader.db')

c = conn.cursor()

#Create tables

def create_table():
	c.execute('''CREATE TABLE assignment (name text, due_date text, max real, received real)''')
        # CREATE TABLE assignment ( id integer primary key autoincrement, type text, index integer, name text, due integer, max integer, received integer, note text )
	add_entry()

def view_table():
	c.execute('SELECT * FROM assignment')
	results = c.fetchall()
	for result in results:
		print ''
		print 'name: ' + result[0]
		print 'due: ' + result[1]
		print 'received: ' + str(result[2])
		print 'max: ' + str(result[3])
		print ''

def drop_table():
	c.execute('DROP TABLE assignment')	

def add_entry():
	print "how many assignments would you like to enter?"
	ass_num = input()

	i=0;
	while i < ass_num:
		
		print "received:"
		received = [i]
		received[i] = input()

		print "max:"
		max = [i]
		max[i] = input()

		print "name:"
		name = [i]
		name[i] = raw_input()

		print "due date:"
		due_date = [i]
 		due_date[i] = raw_input()


		#Insert data
		c.execute("INSERT INTO assignment VALUES (?, ?, ?, ?)", (name[i], due_date[i], max[i], received[i]) )

		print "name: " + name[i]
		print "received: " + str(received[i])
		print "max: " + str(max[i])
		print "due date: " + due_date[i]

		i+=1

	#Save changes
	conn.commit()


if __name__ == "__main__":
	loop = True
    	while loop:
		print '1. create table'
                print '2. add entry'
	        print '3. view table'
       		print '4. drop table'
        	print '5. quit'
        	x = input()

	        if x == 1:
        		create_table()
		elif x == 2:
			add_entry()
        	elif x == 3:
        		view_table()
        	elif x == 4:
			drop_table()
                elif x == 5:
			conn.close()
			loop = False


