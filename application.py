import os
import sqlite3
from flask import Flask, render_template, request, redirect, url_for, g

# this is the path of the sqlite3 db file
DATABASE = 'tmp/flashcard.db'

# the admin credentials is hardcoded for simulation purposes
ADMIN_USERNAME = 'admin'
ADMIN_PASS = 'adm1n'

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

    user = query_db('SELECT * FROM users WHERE username = ?', 
                    [username], one=True)

    # add the user into the database if it doesn't exist
    if user is None:
        get_db().execute('INSERT INTO users (username) VALUES (?)',
                     [username])
        get_db().commit()

    return redirect(url_for('userDashboard', username=username))

@app.route('/user/<username>')
def userDashboard(username):
    return render_template('user.html', user=username)

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
