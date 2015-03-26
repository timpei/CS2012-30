import os
import sqlite3
from flask import Flask, render_template, request, jsonify, g

DATABASE = 'db/flashcard.db'

ADMIN_USERNAME = 'admin'
ADMIN_PASS = 'adm1n'

DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)

def query_db(query, args=(), one=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv

@app.route('/')
def login():
    return render_template('login.html')

@app.route('/submit_login', methods=['POST'])
def submitLogin():
    username=request.form['username']

    user = query_db('select * from users where username = ?',
                    [username], one=True)

    if user is None:
        return 'No such user'
    else:
        return the_username, 'has the id', user['user_id']
    #return render_template('form_action.html', name=name, email=email)

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = connect_to_database()
    return db

def connect_to_database():
    return sqlite3.connect(DATABASE)

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

# USE:
# python
# from yourapplication import init_db
# init_db()
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)