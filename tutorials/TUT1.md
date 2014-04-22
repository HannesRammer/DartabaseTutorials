## Tutorial1: database connected dart application
 
<dl>
  <dd>
This tutorial will show how to connect your dart appplication, server and client side, to a PostgreSQL or MySQL database.
<br/>
using <a href="http://pub.dartlang.org/packages/dartabase_migration">Dartabase Migration</a> and <a href="http://pub.dartlang.org/packages/dartabase_model">Dartabase Model</a>   
  </dd>
</dl>

###Prerequisits

<dl>
  <dd>
Though not needed, it might be usefull to bring some understanding of polymer elements and server client communication into this tutorial.
</br>
If you want to know more about:
</p>
server client communication I can recommend you <a href="https://www.dartlang.org/articles/json-web-service/">JSON WEB SERVICES</a> by Chris Buckett
</p>
for more information on Polymer please read 
<a href="https://www.dartlang.org/polymer-dart/">POLYMER DART</a>
</p>
and for nice Polymer examples check out 
<a href="https://github.com/sethladd/dart-polymer-dart-examples">POLYMER DART EXAMPLES</a> by Seth Ladd
  </dd>
</dl>

###Getting Started

<dl>
  <dd>
1. Download 
<a href="https://github.com/HannesRammer/DartabaseTutorials">Dartabase Tutorials</a> from git and open it's root folder in the Dart Editor via *Open Existing Folder*
</p>
2. Download latest stand alone version of 
<a href="http://pub.dartlang.org/packages/dartabase_migration#versions">Dartabase Migration</a> from pub, extract the zip somewhere to your drive and open the root (lets call it dartabase_migration) folder of the extracted content via "Open Existing Folder"
</p>
3. Run 'Pub Get' on dartabase_migration/pubspec.yaml
  </dd>
</dl>

###Migration Set Up

<dl>
  <dd>
Migration is a tool to build database table and column structures for your MySQL or PostgreSQL database using json files. 
</p>
Before we can use its features, we have to initiate migration once for each project we want to use it with.

 1. Execute "dartabase_migration/bin/dbInit.dart"
    
  this process will establish a connection between dartabase_migration and your project. 

 2. Follow the instructions see from the dbInit.dart output window
  
    1. insert a project name and hit enter (lets use 'todo' without ')
    
    2. insert absolute path to the project root folder (on my machine its 'C:\Projects\Dart\DartabaseTutorials\examples\PreTutorialMixApp' without ') 

    Your output should look like this
      <img src="https://raw.github.com/HannesRammer/DartabaseTutorials/master/tutorials/img/initDB.PNG" >

 Once you hit enter, dartabase_migration should created the files and folders listed below
 the output dialog should look like this
  
  <img src="https://github.com/HannesRammer/DartabaseTutorials/blob/master/tutorials/img/postInitDB.PNG" >
 
 <b>dartabase_migration/bin/projectsMapping.json</b>         
  - maps project names to absolute project paths for interaction between tool and programm <br/><br/>

 <b>yourProjectName/db/</b>
  - folder used by dartabase tools <br/><br/>
 
 <b>yourProjectName/db/config.json</b>          
  - the dartabase config file is a simple json structure used to set IP/PORT/DBType for DB connection <br/><br/>
      
 <b>yourProjectName/db/schema.json</b>
  - schema is the current migrated version of the database structure as JSON used by dartabase tools <br/><br/>
      
 <b>yourProjectName/db/schemaVersion.json</b>
  - safes name of latest migrated version file <br/><br/>
  
 <b>yourProjectName/db/migrations</b>
  - you have to keep the migration files inside this folder! <br/><br/>

 3. Open the <b>yourProjectName/db/config.json</b> file and adapt the file with your existing empty database config data

  In this tutorial we use a PostgeSQL database <b>called</b> 'todoList' 
  <br/>
  with <b>user</b> 'postgres', <b>password</b> '1234' <b>running on</b> 'localhost:5432'
  <br/><br/>
  the config file should look like this now
  <pre>
    --------config.json---------
    {
      "adapter": "PGSQL",
      "database": "todolist",
      "username": "postgres",
      "password": "1234",
      "host": "localhost",
      "port": "5432"
    }
  </pre>
    if you prefer to use MySQL use "MySQL" as the adapter instead

   We are ready to create our first database migration! yeah

*******************************************************************************************
HOW TO CREATE MIGRATIONS
------------------------
  
Either
  
1a.execute dartabase_migration/bin/createMigration.dart and follow the instructions
  
  *enter project name
  *enter migration name eg. "create_table_user"
  
  it will create a dummy migration inside
  
  "$yourProjectName/db/migrations/YYYYMMTTHHMMSS_create_table_user" 
  
or
  
1b.Create a migration json file "timestamp_action.json" 

    inside "$yourProjectName/db/migrations"

    eg. "$yourProjectName/db/migrations/20130709134700_create_table_user.json"

2.inside your migration file you have a fixed structure!

    a JSON object with a key "UP" and a json object value

    to use migrations you can specify the keys/actions below inside the "UP" value

**createTable**
    
    "createTable" key takes a json object as value

        keys    : non_existent_table_names (lower_case)
        values  : json object
                    keys    : non_existent_column_names (lower_case)
                    values  : DARTABASETYPE
                          or
                          json object
                          keys: column options 
                          values: column option values 

    type only
    "createTable": {
      "new_table_name_one": {
        "new_column_name": "DATATYPE"
        }
      }
      
        or with options          
        "createTable": {           
            "new_table_name_one": {        
                "new_column_name": {          
                  'type':"DATATYPE",      
                    'default':"1234"    
                }                
            }                
        }

**createColumn**
    
    "createColumn" key takes a json object as value

        keys    : existing_table_names (lower_case)
        values  : json object
                    keys    : non_existent_column_names (lower_case)
                    values  : DARTABASETYPE
                          or
                          json object
                          keys: column options 
                          values: column option values 

    type only
    "createColumn": {
      "existing_table_name_one": {
        "new_column_name": "DATATYPE"
        }
      }
        
        or with options
        "createColumn": {          
            "existing_table_name_one": {    
                "new_column_name": {         
                  'type':"DATATYPE"      
                }              
            }
        }

**removeColumn**
    
    "removeColumn" key takes a json object as value

        keys    : existing_table_names (lower_case)
        values  : array[existing_column_names] (lower_case)

        eg.
        "removeColumn": {
            "existing_table_name_one": ["existing_column_name_one"]
        }

**removeTable**
    
    "removeTable" key takes array of existing_table_names

        eg.
        "removeTable": ["existing_table_name_one"] (lower_case)
        
**createRelation**
    
    "createRelation" key takes an array of arrays with two existing table names as value

        value  : array[array[existing_table_name_one,existing_table_name_two]] 

        eg.
        "createRelation": [
          ["existing_table_name_one","existing_table_name_two"]
      ]
        
**removeRelation**
    
    "removeRelation" key takes an array of arrays with two existing table names as value

        value  : array[array[existing_table_name_one,existing_table_name_two]] 

        eg.
        "removeRelation": [
          ["existing_table_name_one","existing_table_name_two"]
      ]
      
A simple migration could look like

    ----------20130709134700_create_table_user.json--------------
    {
        "UP": {
            "createTable": {
                "account": {
                    "name": "VARCHAR"
                },
                "picture": {
                    "file_name": "VARCHAR"
                }
            },
            "createRelation": [
              ["picture","account"]
            ]
        },
        "DOWN": {
          "removeRelation": [
              ["picture","account"]
            ],
            "removeTable": ["account","picture"]
        }
    }

createTable creates a table named  
"account" with column "name" and datatype "variable length of characters"
"picture" with column "name" and datatype "variable length of characters"

createRelation creates a table named
"account_2_picture" with columns "account_id" and "picture_id"


*******************************************************************************************
COLUMN ID
---------

The 'id' column will be generated by 'Dartabase Migration' for every table 
as primary key. 
  
  Dont add 'id' in any of the migration files.
  
This is to let 'Dartabase Model' decide when to create or update an Object
on save() - see [Dartabase Model](http://pub.dartlang.org/packages/dartabase_model)     
       
*******************************************************************************************
COLUMN CREATED/UPDATED
----------------------

For each table a created_at and updated_at column will be generated automatically.
    
    created_at 
      will only be set to current datetime on creation of table row entry 
    
    updated_at 
      will be set to current datetime on creation of table row entry
      PGSQL
        will be updated when the row has been saved
      MySQL
        will be updated when the row has been saved and a value of the row changed 
         
*******************************************************************************************
COLUMN OPTIONS
--------------
  
following options are awailable for columns
  
  option      values      
  "type"     ->   "DARTABASETYPE"     <---always needed
  "default"  ->   "yourDefaultValue"  <---optional 
  "null"     ->   "true" or "false"   <---optional 
  
if options are not set then it should use dbAdapter standart settings  
  
example
  
  "createColumn": {
        "player": {
            "player_name": {
              'type':"VARCHAR",
              'null':"false",
              'default':"unnamed Player"
            }
        }
    }

*******************************************************************************************

UP AND DOWN
-----------

Additionally to the "UP" key you can specify all actions inside the "DOWN" key

    actions inside "UP" are executed during migration
    actions inside "DOWN" are executed when reverting migrations

since we created a table named "user", 
we might want to remove it once we want to revert the migration

    !!!ATTENTION be sure your don't need the data inside a table/column 
    before you remove it!!!

*******************************************************************************************
ORDER OF EXECUTION
------------------

Once you have more than one action in the migration file

    eg.
      adding a column
      adding a table
      removing a column

remember that the order of execution inside a migration will be

    createTable
     ->
     createColumn
      ->
      removeColumn
       ->
       createRelation
        ->
        removeRelation
         ->
         removeTable

but I cant think of a feasible example where that might bring up problems.

*******************************************************************************************
HOW TO RUN MIGRATIONS
---------------------

1.Execute dartabase_migration/bin/dbUp.dart

2.Follow instructions in console
    
        *enter project name
        *enter goal migration version

dartabase_migration should have executed the actions specified inside the "UP" key
for all files INCLUDING the goal migration version.

Additionally it will update

    *$yourProjectName/db/schema.json
    with the current database structure as JSON

    *$yourProjectName/db/schemaVersion.json
    with the name of latest migrated migration file

HOW TO REVERT MIGRATIONS
------------------------

1.Execute dartabase_migration/bin/dbDown.dart 

2.Follow instructions in console
    
    *enter project name
    *enter goal migration version 

dartabase_migration should have executed the actions specified inside the "DOWN" key
for all files EXCLUDING the goal migration version.

Additionally it will update

    *$yourProjectName/db/schema.json
    with the current database structure as JSON

    *$yourProjectName/db/schemaVersion.json
    with the name of latest migrated migration file


*******************************************************************************************

DARTABASE DATA TYPES
--------------------
dartabase_migration types are Specified in capitals.

on the left hand you see the dartabase_migration data type name
on the right the data type your database will use




*******************************************************************************************
Now you can add migration files for simple database manipulation

TODO
----

  *fix async outputtext
  *workarround for database problems with reserved words 
   on creation or when switching DBAdapter from PG to MY.
        eg. table name 'user' will break in MySQL
        fix -> add '_' as prefix to all column and table names
    *test on other systems
    *adding rename action
    *adding option to specify variable length
        currently VARCHAR fix at 255
    *test functionality of all data types
    *improvements, adapt more functionality from db connectors
    *and much more

Please let me know about bugs you find and or improvements/features you would like to see in future.

ENJOY & BE NICE ;)

**Structure
  
  In generel the example is a simple todo list webapp using polymer
  
  The server is located inside the /bin folder and consists of 

    -a simple server 
    -an Item class 
  
  The client is inside the /web folder and consists of 

    -a start page index.html inside /web 
    -a Item polymer element inside /web/poly 
    -Item views 'index', 'view', 'create', and 'edit' inside /web/Item  
