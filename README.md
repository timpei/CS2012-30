# CS2012-30

CS2012 DB Project Group 30


# Setup
1. Open the terminal and clone the repo by typing in the following:
```
git clone https://github.com/timpei/CS2102-30.git
```

2. Set up the environment. First make sure you have /usr/local/bin defined in your $PATH variable.
```
export PATH=/usr/local/bin:$PATH
```
Check by typing 
```
echo $PATH
```
in the terminal and looking for /usr/local/bin

3. Run the following commands line by line.
```
sudo easy_install pip
pip install virtualenv
```

4. Go into your repository. 
```
cd CS2102-30
```

5. Run some more commands
```
virtualenv env
. env/bin/activate
pip install -r requirements.txt
```

6. You should be able to run the website by typing 
```
python application.py
```
in your environment.

7. Open your browser to localhost:5000/ and you're all set.


From now on, to start the application, you only need to run the following two commands inside your CS2102-30 folder
```
. env/bin/activate
python application.py
```

