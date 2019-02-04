# zDepth_Render Description

Z-Depth Rendering is a technique applied to videos to add an impression of depth as objects in the video move towards or away from the spectator
Contains a complete workflow to capture Video in a greenscreen environment (Sensorimotor CAVE Bern), extract z-Depth-data and Render in Unity.  

![drawing](https://imgur.com/fuTRBxg.jpg)



## Pipeline
01_Capture: Setup for Lab to record data /w synchronized depth and video output  
02_Greenscreen: Description of Premiere Pro workflow to Unity. Goal: Add transparent alpha channel to video and export to Unity  
03_DepthExtraction: Extract synchronized z-Data as txt-file  
04_DepthFeed: Read txt-file in Unity and synchronize to game time  
99_Example: Source to game-ready example of an applied scenario  

## Software Requirements
[Unity3D](https://unity3d.com/de)   
[Matlab](https://ch.mathworks.com/de/products/matlab.html), and the [BTK toolbox](http://biomechanical-toolkit.github.io/docs/Wrapping/Matlab/_tutorial.html)
[PremierePro](https://www.adobe.com/PremierePro) (Trial version suffices)  
[WebM](https://www.fnordware.com/WebM/) (Plugin for Premiere Pro Video Export)
[Motive](https://optitrack.com/products/motive/)

## Hardware Requirements
GoproHero Camera (Or similar)  
Optitrack

## Tested with
Unity3D 2018.3f  
Matlab R2017b  
PremierePro CC2018  
WebM_v1.1  
Motive v1.7?

# Instructions

## 03_DepthExtraction: Instructions for extracting the depth data from .c3d file using Matlab

### Accessing files from Optitrack
- In optitrack, the files need to be exported as .c3d files. 
- In case multiple takes have to be exported, use the Motive [Batch Processor](https://v20.wiki.optitrack.com/index.php?title=Motive_Batch_Processor)

### Setting up workspace
- Add all the scripts from 03_DepthExtraction to a folder of choice and run the script

### Setting private parameters
- In the main script (Skript_Z_Depth_Analysis_refined.m), the section "Necessary user input" needs to be specified
- In the main script, the Input for the function "findStandingUpEvent()" contains a parameter for the height of the subject measured. I suggest to take a value 10 cm shorter than the height of the subject (e.g. the subject is 170 cm, use 160)
- If the function "findStandingUpEvent()" doesnt yield meaningful outputs, there are two private parameters in the function itself that can be adjusted (tresh & gap)

### Output
Given the script runs smoothly, two figures are saved as .jpg and two z-depth files are produced and saved as .csv files. The plots should look approximately like the following:



