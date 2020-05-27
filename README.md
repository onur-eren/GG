# GG
- This project originally created to carry a project from a local path into the github resository
- To do this, Create a single file to accomplish goal.
- Success. Main.bat is the main file
- Steps
  - **Git** : Init, commit, add remote
  - **Github** : create/delete-create
  - **Git** : push

## Concepts:
- ENV SETTINGS
- DEBUG
- Color
- SINGLEFILE
- APP SETINGS
- Experimental

# ENV SETTINGS
./env folder need github.txt with your github line1:username, line2:token to allow create,read,write cridentials. <br />
There is an example file exp.github.txt


# DEBUG
- APP_DEBUG set the debug level. The higher will print more. Currently max is 4 and APP_DEBUG=1 is empty for your custom DEBUG
- Debug works with GEQ (Great Equal) equation. So if your APP_DEBUG setting is greaterEqual to code's debug it would be included
> Example: APP_DEBUG=3 setting will dump also debug  APP_DEBUG level 2 and APP_DEBUG level 1
- Some high APP_DEBUG levels pause code for easy navigation 

# PREDEFINED VARAIBLE for README 
**RGB**: RED_CODE(255) BLUE_CODE(255) GREEN_CODE(255) <br />
> Example: 255 0 15 <br />

**INDEX**: integer of index that the color you would like to use. This Index sould start from 0 and increased by ++

# COLOR
### INIT
> color.bat

### ADD
To add foreground color:
> color.bat ~ INDEX frgb RGB

To add background color:
> color.bat ~ INDEX brgb RGB

To add foreground(First RGB) and background(Second RGB):
> color.bat ~ INDEX frgb RGB RGB

To add background(First RGB) and foreground(Second RGB):
> color.bat ~ INDEX brgb RGB RGB

### CHANGE COLOR
> color.bat ~ INDEX

### CHANGE COLOR to Previous color
> color.bat -1

# SINGLEFILE
Each file can be called individually. This method called as a SINGLEFILE and code variables named with SF_ prefix

# APP SETINGS - Advance
Modified/Custom Libraries can be setup on settings.bat

# Experimental
Further color. No use found so far.
> color.bat +1
