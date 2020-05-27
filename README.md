# GG
- This project originally created to carry a project from a local path into the github resository
- To do this, Create a single file to accomplish goal.
- Success. Main.bat is the main file
- Steps
  - git: Init, commit, add remote
  - github: create/delete-create, push

## Concepts:
- SINGLEFILE concept
- Color concept
- DEBUG concept
- SETINGS concept

## SINGLEFILE
Each file can be called individually. This method called as a SINGLEFILE and code variables named with SF_ prefix

## DEBUG
- APP_DEBUG=2 ECHO messages/errors/dump arrays
- APP_DEBUG=1 is empty for your custom DEBUG
- APP_DEBUG works with GEQ. So if your APP_DEBUG setting is greaterEqual to code's debug it would be included 

## SETINGS
Modified/Custom Libraries can be setup on settings.bat

## COLOR
- RGB: RED_CODE(255) BLUE_CODE(255) GREEN_CODE(255)
  - Example: 255 255 255
- INDEX: integer of index that the color you would like to use. This Index sould start from 0 and increased by ++

### INIT
color.bat

### ADD
To add foreground color:
color.bat ~ INDEX frgb RGB

To add background color:
color.bat ~ INDEX brgb RGB

To add foreground(First RGB) and background(Second RGB):
color.bat ~ INDEX frgb RGB RGB

To add background(First RGB) and foreground(Second RGB):
color.bat ~ INDEX brgb RGB RGB

### CHANGE COLOR
color.bat ~ INDEX

### CHANGE COLOR to Previous color
color.bat -1

### Experimental
color.bat +1 further color. No use found so far.