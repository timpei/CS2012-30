import os
import sqlite3
from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for, g

import consts

# this is the path of the sqlite3 db file
DATABASE = 'tmp/flashcard.db'

# this is an attribute that will be used by flask
# setting DEBUG to true will allow you to trace server activities from terminal
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)

# used to run SQL queries
# setting one to true will only return the first (or only) result
def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

# gets an instance of the database cursor 
# (which allows you to run sqlite actions)
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = connect_to_database()
    return db

# opens a sqlite3 connection
def connect_to_database():
    return sqlite3.connect(DATABASE)

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

# this is run to initialize the database
# used if the server is started for the first time
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()


"""
WEB PAGES
"""

@app.route('/')
def login():
    return render_template('login.html')

@app.route('/submit_login', methods=['POST'])
def submitLogin():
    # get the post variable for username (from the form)
    username=request.form['username']
    password=request.form['password']

    # get user information
    user = query_db('SELECT * FROM User WHERE username = ?',
                    [username], one=True)

    # if user doesn't exist or password is incorrect
    # TODO(sumin): Decode password
    if user is None or user[5] != password:
        return render_template('login.html', failed=True)

    return redirect(url_for('userDashboard', username=username))

@app.route('/submit_signup', methods=['POST'])
def submitSignup():
    # get all the sign up information from the form
    username=request.form['username']
    password=request.form['password']
    firstname=request.form['firstname']
    lastname=request.form['lastname']
    email=request.form['email']
    birthday=request.form['birthday']
    avatar=request.form['inlineRadio']

    # TODO(sumin): Encode password
    # add the user into the database if it doesn't exist
    get_db().execute('INSERT INTO User '
                     '(username, firstName, lastName, email, birthday, password,'
                     'isAdmin, avatar, lastLogin, registerDate) VALUES '
                     '(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                     [username, firstname, lastname, email, birthday, password,
                      False, avatar, datetime.now(), datetime.now()])
    get_db().commit()

    # boolean for insert success (always success for now)
    # TODO(sumin): Check the db execute function to see if insert was successful
    success=True

    return render_template('login.html', signUp=True, success=success)

@app.route('/user/<username>')
def userDashboard(username):
    return render_template('user.html', user=username)

@app.route('/user/<username>/create')
def createUser(username):
    user = query_db('SELECT * FROM User WHERE username = ?', 
                    [username], one=True)

    return render_template('create.html', user=user, 
                                        languages=consts.LANGUAGES,
                                        categories=consts.CATEGORIES)



# starts the server 
if __name__ == '__main__':

    # first check to see of the machine has set an environment variable for port
    # if not, use port 5000
    port = int(os.environ.get('PORT', 5000))

    # if the database does not exist, initialize it
    if not os.path.exists('tmp'):  
        os.makedirs('tmp')
        init_db()

    # starts the server at localhost
    app.run(host='0.0.0.0', port=port)
