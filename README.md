# Install joplin server on Ubuntu (20.04, 22.04)

1. as root run `joplin-requirements.sh` to install the joplin requirements but please take this script with causion since it is not well tested in existing environments. Root privileges are needed to get the packages to be installed. You can run `sudo bash -x joplin-requirements.sh` to see what it's doing. 

    You could also create the requirements by yourself by:
    
    1. create user joplin with home `/home/joplin`
    2. install nodejs 18
    3. install packages `vim git build-essential python curl dirmngr apt-transport-https lsb-release ca-certificates`
    4. checkout your desired version from https://github.com/laurent22/joplin.git to `/home/joplin`
    
2. collect expected files and folders and build joplin by running `joplin.sh build`.  This must be run as the joplin user. If you run it with debug flag `sudo -u joplin bash -x joplin.sh build` you could see what's it's doing.

3. create a new db `joplin` in postgres (running on the same or on another server) and adapt `run.sh` with your db credentials. You can use `psql` to do this, for example:

    ```sql
    sudo -u postgres psql
    CREATE USER joplin WITH PASSWORD 'your-secret-password-here';
    CREATE DATABASE joplin;
    ALTER DATABASE joplin OWNER TO joplin;
    GRANT ALL PRIVILEGES ON DATABASE joplin TO joplin;
    \q
    ```

4. create a new file `.joplinrc` containing the variables you want to overwrite from the `run.sh`'s defaults. e.g.
    ````
    POSTGRES_PASSWORD="your-secret-password-here"
    APP_BASE_URL="https://joplin.mydomain.org"
    ````
    
5. test `run.sh`

    - To do that run it as the joplin user: `sudo -u joplin run.sh` and it should provide you with a URL to test like this:
        `App: Call this for testing: 'curl https://yourdomain/api/ping'`

6. if `run.sh` works as expected the `curl` reports:
    `{"status":"ok","message":"Joplin Server is running"}`
    then, you can use `joplin.service` to run joplin as a systemd service as follows:

    1. edit the `joplin.service` file to make sure in particular that `ExecStart` points to a copy of `run.sh` that is executeable and you tested above.
    2. `sudo cp joplin.servce /etc/systemd/system`
    3. `sudo systemctl daemon-reload`
    4. `sudo systemctl enable joplin`
    5. `sudo service joplin start`
    6. `sudo service joplin status`
    7. Then to the curl test again

7. in the `webserver` folder you find an configuration examples how to access the Joplin server from your reverse proxy (if your webserver is not included, and you get it configured please contribute a config example)

8. Once it's running you can surf to the server you tested with curl above in your browser (https://yourdomain), then login with the email `admin@localhost` and passowrd `admin`. Change the admin password, create yourself a new user and you're rolling.

# Update

```
sudo systemctl stop joplin
```

then as user joplin:
````
cd ~/joplin
./joplin.sh checkout-latest
./joplin.sh build
````

if build run successfull you could install and test:

```
./joplin.sh install
./joplin.sh run
```

if joplin server starts without error you could exit with ctl-c and start the service

```
sudo systemctl start joplin
```


s. [Joplin Server pre-release is now available](https://discourse.joplinapp.org/t/joplin-server-pre-release-is-now-available/13605/176)
