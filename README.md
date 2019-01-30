# zDepth_Render Description

Z-Depth Rendering is a technique applied to videos to add an impression of depth as objects in the video move towards or away from the spectator
Contains a complete workflow to capture Video in a greenscreen environment (Sensorimotor CAVE Bern), extract z-Depth-data and Render in Unity.  

![drawing](https://imgur.com/fuTRBxg.jpg)



# Pipeline
01_Capture: Setup for Lab to record data /w synchronized depth and video output  
02_Greenscreen: Description of Premiere Pro workflow to Unity. Goal: Add transparent alpha channel to video and export to Unity  
03_DepthExtraction: Extract synchronized z-Data as txt-file  
04_DepthFeed: Read txt-file in Unity and synchronize to game time  
99_Example: Source to game-ready example of an applied scenario  

# Software Requirements
[Unity3D](https://unity3d.com/de)   
[Matlab](https://ch.mathworks.com/de/products/matlab.html)  
[PremierePro](https://www.adobe.com/PremierePro) (Trial version suffices)  
[WebM](https://www.fnordware.com/WebM/) (Plugin for Premiere Pro Video Export)
[Motive](https://optitrack.com/products/motive/)

# Hardware Requirements
GoproHero Camera (Or similar)
Optitrack

# Tested with
Unity3D 2018.3f  
Matlab R2017b  
PremierePro CC2018  
WebM_v1.1  
Motive v1.7?


