# zDepth_Render Description

Z-Depth Rendering is a technique applied to videos to add an impression of depth as objects (e.g. players) in the video move towards or away from the spectator.  
Contains a complete workflow to capture Video in a greenscreen environment (Sensorimotor CAVE Bern), extract z-Depth-data and Render in Unity.  

![drawing](https://imgur.com/fuTRBxg.jpg)




### Pipeline
01_Greenscreen: Description of Premiere Pro workflow to Unity. Goal: Add transparent alpha channel to video and export to Unity  
02_DepthExtraction: Extract synchronized z-Data as txt-file  
03_DepthFeed: Read txt-file in Unity and synchronize to game time  
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
Unity3D 2019.1.0b2  
Matlab R2017b  
PremierePro CC2018  
WebM_v1.1  
Motive v1.7?




# Step by step instructions

### Capture in Optitrack environment

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

### 01_Greenscreen: Instructions for preparing the greenscreen video

#### Import video in Premiere Pro
- Open Premiere Pro CC
- Right click the [import](https://filmora.wondershare.com/adobe-premiere/adobe-premiere-import-export.html) section and select the video  
- In the project folder, right click on the imported video and chose "create sequence from clip". A new sequence with the same name is created just below the video file ([tutorial](https://helpx.adobe.com/ch_de/premiere-pro/how-to/create-edit-sequence.html)). Rightlick and rename the sequence, then double click to open  
- [Cut](https://www.youtube.com/watch?v=YJhJuuPAzvg) video so that the video starts at the frame when the subject reaches the marker tape height after standing up  

#### Apply Key for the Greenscreening effect
- Apply the "[Ultra Key](https://www.youtube.com/watch?v=p-sZyzs-fnI)" Effect to the timeline.  
- The settings for the Ultra Key can bei imported from the Preset file (.../01_Scripts/UltraKeyPreset.prfpset). The preset file can be added to the Premiere Project [the following way](https://www.youtube.com/watch?v=cV3XFTiRXt4)  
- In the "Effect Controls" window (Shift+5), the settings of the ultra Key can be adjusted. Most importantly, the settings under "Matte Generation" are of interest to mask all background  
- After the application, the background around the player should be subtracted and should yield a result like [this](https://imgur.com/1xUoAjd)  


#### Crop the video to body height for each frame
- Since the video will be displayed in real size, the subject in the video has to be scaled to fit the frame size troughout the video, like [here](https://youtu.be/ze-whcJwS2A)
- Suggestion is to use [Keyframe animation](https://www.youtube.com/watch?v=GR-bEGYi8D4). The subject is scaled to fit the vertical height. Then, the position is adjusted to make the subject fit vertically in the video. The horizontal component is not changed if possible
- Note: If the recorded movements are strong in horizontal dimension (e.g. the subject walks out of the frame horizontally after scaling, the x-Component could also be rendered separately, analogously to the procedure in Chapter 03)
- After Keyframing, the subject should alwyas appear fully scaled in the frame, similar to [here](https://imgur.com/a/e7H2mB3).  

#### Install WEBM plugin
- The Plugin needs to be downloaded and installed from [here](https://www.fnordware.com/WebM/). It is necessary to display the transparent background as an alpha channel in Unity5

#### Export video
- With the timeline selected, press Ctrl+M to bring up export window
- On the right side, under `Format`, the WebM should be accessible
- For the preset, select `import preset` and chose WebMforUnity.epr (located under .../02_Greenscreen/01_Scripts)
- Click on the blue text by `Output field` to chose where to save the video
- Export the video

#### Alternative to WEBM Premiere Pro plugin
- Use the ffmpeg plugin [to decode a video with an alpha channel to become a webm file](https://developers.google.com/web/updates/2013/07/Alpha-transparency-in-Chrome-video). The [ffmpeg library](https://github.com/adaptlearning/adapt_authoring/wiki/Installing-FFmpeg) is required for this.
- The export in Premiere Pro should [produce .png files](https://youtu.be/ukY2IGDXSAU)
- The created image sequence can be [processed with the ffmpeg](https://stackoverflow.com/questions/34974258/convert-pngs-to-webm-video-with-transparency)library into a webm video file:  
``ffmpeg -i frames/%03d.png output.webm``


### 02_DepthExtraction: Instructions for extracting the depth data from .c3d file using Matlab

#### Accessing files from Optitrack
- In optitrack, the files need to be exported as .c3d files. 
- In case multiple takes have to be exported, use the Motive [Batch Processor](https://v20.wiki.optitrack.com/index.php?title=Motive_Batch_Processor)

#### Setting up workspace
- Add all the scripts from 03_DepthExtraction to a folder of choice and run the script

#### Setting private parameters
- In the main script (Skript_Z_Depth_Analysis_refined.m), the section `Necessary user input` needs to be specified
- In the main script, the Input for the function `findStandingUpEvent()` contains a parameter for the height of the subject measured. I suggest to take a value 10 cm shorter than the height of the subject (e.g. the subject is 170 cm, use 160)
- If the function `findStandingUpEvent()` doesnt yield meaningful outputs, there are two private parameters in the function itself that can be adjusted (tresh & gap)

#### Output
Given the script runs smoothly, two figures are saved as .jpg and two z-depth files are produced and saved as .csv files. The plots should look approximately like the following:
![drawingpicture](https://serving.photos.photobox.com/840213009ef0356649343b5a5433b8e9a92c9eecf93493449d85af2925d7565e7154d199.jpg)  
The graph on the left shows the raw data compared to the filtered data. The graph on the right shows the height of the head marker over time. The script identifies the events when the subject crouched (blue) as well as the first frame the participant approximately reached full body height after standing up (red)


### 03_DepthFeed
#### Setup scene and video
- To implement these steps you require a .csv file for Unity, a transparent Webm Video (VP8)
- Create a `quad` matching the height of the subject. The ratio of width and height of the `quad` should be the same as the video output (e.g. 16:9 through 1920x1080)
- Create a [video player](https://unity3d.com/de/learn/tutorials/topics/graphics/videoplayer-component) and add it as a component to the quad
- Drag the video into the project folder. Clicking on the video, tick `Keep Alpha` and tick `Transcode`. In the transcoding area, chose: Dimensions = Original; Codec: VP8; then hit `apply` (see also [tutorial](https://forum.unity.com/threads/settings-for-importing-a-video-with-an-alpha-channel.457657/)
- After the video is imported, the now transparent video file has to be dragged onto the video component

- Use `Create` to make a new material. Open the new material in the asset window and change the `shader`. Use the [CustomUnlitCutout.shader](https://gist.github.com/setchi/b5c9fd72c3cb5317dae44cb6f3eb7fef) from the repository.
- Drag the transparent material onto the quad as a new component


#### Setup CSV reader
- The `CsvFileReader.cs` is to be downloaded from the repository and added as a component to the quad.
- The file `Short_008.csv` provides exemplary values for the file reader. After adding the csv to the asset folder, drag the csv onto the `CsvFileReader` Component
- The `CsvFileReader` component requires specification about the object that needs to be moved. Drag the quad into the `Object to be moved`
- Hit play

#### Make the video face the observer
- the Script `LookAtCamera` can be added to the `quad`. Drag the `Camera` to the `Target` slot.
- In case the video is rotated 180 degrees in the wrong direction, the `changeDîrection` component can be ticked to set the rotation to 0.
- The result should look like [this](https://youtu.be/rOQ5o80O0I4)


### 99_Example
- A unity package `zDepthExample.unitypackage` is accessible in the library. In any compatible Unity project, the package can be imported or dropped into the assets folder.
- In the package, the Object `Quad` is used as a surface for a Webm-Video. In this package, two video players are attached to the `Quad`: The active player pulls an exemplary Video from the internet. If you have your own Webm Video on your drive, you can link it to the second (inactive) video player to display

Contact: email.daniel.ch@gmail.com  http://www.science.football





