first open your commandbox (CMD)

then change directory to the main folder of the Script

example:
````````````````````````````````````````````````````````
cd C:\Users\User\Desktop\texturesplitter
````````````````````````````````````````````````````````

after you are inside the correct directory, change

put the textures inside of the input folder (if no input folder exist create one)

after you put all textures inside the input folder

type this command inside your commandbox (CMD)


````````````````````````````````````````````````````````
python main.py
````````````````````````````````````````````````````````
  

after running the command you have a output folder with subfolders

make out of every folder a new texture (.ytd) with OpenIV


example model name is mercedes
````````````````````````````````````````````````````````
folder0 -->  mercedes.ytd
folder1 --> mercedes1.ytd
folder2 --> mercedes2.ytd
folder3 -- mercedes3.ytd
````````````````````````````````````````````````````````

replace the new textures (.ytd) with the old texure (.ytd)

then you open the vehicles.meta

on the bottom of the file you can see 

<txdRelationships>
...
...
</txdRelationships>

there you need to set the paret/childs
this needs to look like this below

<txdRelationships>
  <Item>
    <parent>mercedes1</parent>
    <child>mercedes</child>
  </Item>
  <Item>
    <parent>mercedes2</parent>
    <child>mercedes1</child>
  </Item>
  <Item>
    <parent>mercedes3</parent>
    <child>mercedes2</child>
  </Item>
  <Item>
    <parent>vehicles_dom_interior</parent>
    <child>mercedes3</child>
  </Item>
</txdRelationships>


after you the parent and childs save the file and start your server now your textures are splitted

