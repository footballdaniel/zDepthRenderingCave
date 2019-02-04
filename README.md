# zDepth_Render Description

Z-Depth Rendering is a technique applied to videos to add an impression of depth as objects in the video move towards or away from the spectator
Contains a complete workflow to capture Video in a greenscreen environment (Sensorimotor CAVE Bern), extract z-Depth-data and Render in Unity.  

![drawing](https://imgur.com/fuTRBxg.jpg)



### Pipeline
02_Greenscreen: Description of Premiere Pro workflow to Unity. Goal: Add transparent alpha channel to video and export to Unity  
03_DepthExtraction: Extract synchronized z-Data as txt-file  
04_DepthFeed: Read txt-file in Unity and synchronize to game time  
99_Example: Source to game-ready example of an applied scenario  

### Software Requirements
[Unity3D](https://unity3d.com/de)   
[Matlab](https://ch.mathworks.com/de/products/matlab.html), and the [BTK toolbox](http://biomechanical-toolkit.github.io/docs/Wrapping/Matlab/_tutorial.html)
[PremierePro](https://www.adobe.com/PremierePro) (Trial version suffices)  
[WebM](https://www.fnordware.com/WebM/) (Plugin for Premiere Pro Video Export)
[Motive](https://optitrack.com/products/motive/)

### Hardware Requirements
GoproHero Camera (Or similar)  
Optitrack

### Tested with
Unity3D 2018.3f  
Matlab R2017b  
PremierePro CC2018  
WebM_v1.1  
Motive v1.7?




# Step by step instructions

## Capture in Optitrack environment
Link to example [video](https://youtu.be/YpsTd9Q8pAo) of this step

#### Camera setup
- Mount Gopro on stative. Lens should be on approximate eye-level for the future Unity environment. Recommended lens height: 1.65m
- Tilt camera to cover the required ground area for all movement
- At the back of the Lab, add a black tape to the wall at the height of the subject. This is a reference point, whether the subject is standing or not (see start capture for implications)
- For optimal lighting, turn the light on by the main door, and turn off all the other lights. The condition should resemble the example [video](https://youtu.be/YpsTd9Q8pAo)

#### Optitrack setup
- Setup and Calibrate Optitrack through Motive Software
- Use basic Markerset for full body capture

- *Alternatively, but not scripted:*
- Attach markerset of three or four markers on the highest head position of subject
- Select markers in Optitrack and add as a rigid body

#### Capture setup
- For best results, the subject should wear all black clothes. White, green or reflective wearables should be taped!

#### Start capture
- The participant is required to start in a crouched position. This is necessary since the Optitrack capture and the video capture will be synchronized by the event, where the subject stands up to full height.
- Press record on camera and record on Optitrack
- The subject can stand up. If the skeleton is not recognized (because of the crouching position, the subject can move after standing up to synchronize full body marker set (this step is not necessary with rigid body alternative)
- Make sure that the subject stands up in front of the black marker (in the video feed, the frame when the subject covers the marker need to be identified later)

#### End capture
- In Motive, export the take as .c3d file 
- With Gopro, copy the .mp4 video to a drive


## 03_DepthExtraction: Instructions for extracting the depth data from .c3d file using Matlab

#### Accessing files from Optitrack
- In optitrack, the files need to be exported as .c3d files. 
- In case multiple takes have to be exported, use the Motive [Batch Processor](https://v20.wiki.optitrack.com/index.php?title=Motive_Batch_Processor)

#### Setting up workspace
- Add all the scripts from 03_DepthExtraction to a folder of choice and run the script

#### Setting private parameters
- In the main script (Skript_Z_Depth_Analysis_refined.m), the section "Necessary user input" needs to be specified
- In the main script, the Input for the function "findStandingUpEvent()" contains a parameter for the height of the subject measured. I suggest to take a value 10 cm shorter than the height of the subject (e.g. the subject is 170 cm, use 160)
- If the function "findStandingUpEvent()" doesnt yield meaningful outputs, there are two private parameters in the function itself that can be adjusted (tresh & gap)

#### Output
Given the script runs smoothly, two figures are saved as .jpg and two z-depth files are produced and saved as .csv files. The plots should look approximately like the following:



