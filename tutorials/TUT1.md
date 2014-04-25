*************************************************
## Tutorial1: database connected dart application
-------------------------------------------------
 
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
Migration is a tool to build version controlled database table and column structures for your MySQL or PostgreSQL database using json files. 
</p>
Before we can use its features, we have to initiate migration once for each project we want to use it with.

 1. Execute "dartabase_migration/bin/dbInit.dart"
    
  this process will establish a connection between dartabase_migration and your project. 

 2. Follow the instructions see from the dbInit.dart output window
  
  1. insert a project name and hit enter (lets use 'todo' without ')
  2. insert absolute path to your project root folder (on my machine its and for this example I use 'C:\Projects\Dart\DartabaseTutorials\examples\PreTutorialMixApp' without ') 

    Your output should look like this
      <img src="https://raw.github.com/HannesRammer/DartabaseTutorials/master/tutorials/img/initDB.PNG" >

 Once you hit enter, dartabase_migration should created the files and folders listed below
 the output dialog should look like this
  
  <img src="https://raw.githubusercontent.com/HannesRammer/DartabaseTutorials/master/tutorials/img/postInitDB.PNG" >
 
 <b>dartabase_migration/bin/projectsMapping.json</b>         
  - maps project names to absolute project paths for interaction between tool and programm <br/><br/>

 <b>PreTutorialMixApp/db/</b>
  - folder used by dartabase tools <br/><br/>
 
 <b>PreTutorialMixApp/db/config.json</b>          
  - the config file is used to set IP/PORT/DBType for DB connection <br/><br/>
      
 <b>PreTutorialMixApp/db/schema.json</b>
  - schema is the current migrated version of the database structure as JSON used by dartabase tools <br/><br/>
      
 <b>PreTutorialMixApp/db/schemaVersion.json</b>
  - safes name of latest migrated version file <br/><br/>
  
 <b>PreTutorialMixApp/db/migrations</b>
  - you have to keep the migration files inside this folder! <br/><br/>

 3. Open the <b>PreTutorialMixApp/db/config.json</b> file and adapt the file with your existing empty database config data

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
    <b>if you prefer to use MySQL use "MySQL" as the adapter instead</b>

   We are ready to create our first database migration! yeah
<br/>

###HOW TO CREATE MIGRATIONS
 To create a database structure, we can now create simple mirgation files!
<br/>
 1. Create a json file "timestamp_action.json" inside <b>"PreTutorialMixApp/db/migrations" </b>
  <br/>
  timestamp format is <b>YYYYMMDDHHMMSS </b>

  eg. <b>"PreTutorialMixApp/db/migrations/20130623043400_create_item.json"</b>
 
 2. inside your migration file you have to follow a fixed structure!

  you can execute actions using a JSON object using a key "UP" or "DOWN" key that each take a json object as a value
  DOWN is manly used to revert actions taken inside the UP

  Some of the actions you can specify are

 **createTable**
    
          "createTable": {
            "new_table_name_one": {
              "new_column_name_one": "DATATYPE",
              "new_column_name_last": "DATATYPE"
            }
            "new_table_name_two": {
            ...
            }
          }
      
 **createColumn**
    
          "createColumn": {
            "existing_table_name_one": {
              "new_column_name_one": "DATATYPE",
              "new_column_name_last": "DATATYPE"
            },
            "existing_table_name_two": {
            ...
            }
          }
 **removeColumn**
    
          "removeColumn": {
            "existing_table_name_one": ["existing_column_name_one"]
          }
 **removeTable**
 
          "removeTable": ["existing_table_name_one"] (lower_case)
 For the todoList we want to create a list item with a text that stored the task and a done field, for once the task is done.
 
 the migration file should look like this

    ----------20130623043400_create_item.json--------------
    
        {
          "UP": {
            "createTable": {
              "item": {
                "text": "VARCHAR",
                "done": {"type":"BOOLEAN","default":"0"}
              }
            }
          },
          "DOWN": {
            "removeTable": [
              "item"
            ]
          }
        }

we have a createTable action that creates a table named "item" with two columns, "text" as a string and "done" as a boolean with default value false

inside the DOWN action we simply add the reverse action. Later we can decide if we want to migrate UP or DOWN making it possible to revert database changes
 
 <b>removing columns or tables from the database will obviously delete the data! so be carefull</b>

*******************************************************************************************
HOW TO EXECUTE MIGRATIONS
-------------------------

1.Execute dartabase_migration/bin/dbUp.dart

2.Follow instructions in console
    
        *enter project name as specified at initialization -> todo
        *enter goal migration version -> 1

dartabase_migration should have executed the actions specified inside the "UP" key.

Additionally it should have updated

    *PreTutorialMixApp/db/schema.json
    with the current database structure as JSON

    *PreTutorialMixApp/db/schemaVersion.json
    with the name of latest migrated migration file

 To revert a migration (execute actions in DOWN key) 
 Execute dartabase_migration/bin/dbDown.dart and follow the instuctions.

 additionally to the two columns, dartabase_migration creates for each table "id", "created_at" and "updated_at" columns, that will be filled automatically!
 
 Now that we have the structure, why not lets use it.
 
 //TODO add modelstuff
 //TODO add client<->server communication code

*******************************************************************************************

**Structure
  
  In generel the example is a simple todo list webapp using polymer
  
  The server is located inside the /bin folder and consists of 

    -a simple server 
    -an Item class 
  
  The client is inside the /web folder and consists of 

    -a start page index.html inside /web 
    -a Item polymer element inside /web/poly 
    -Item views 'index', 'view', 'create', and 'edit' inside /web/Item  
