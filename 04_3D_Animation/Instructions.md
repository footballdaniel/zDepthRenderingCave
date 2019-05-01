
# 3D-Modelling and Animation

This repository contains various 3D modelling attempts for both Unity3D and UnrealEngine4. It includes a chapter about reconstructing and animating a photorealisitic character and a chapter about a virtual 3D model using Optitrack data for animation.



# Adobe Fuse CC characters with Optitrack animations
![Tryptich](https://i.imgur.com/IX3Bzkw.png)  
The left part of the picture is a snapshot from an Optitrack session, where the athlete is wearing a full body marker set. The middle shows the athletes video overlayed in a virtual environment. The right part of the picture shows the athlete approximated by a Fuse CC mesh and animated with Optitrack data.  
The output is also available [as video file](https://youtu.be/IUiwkQzvjBc).

#### Requirements
[Adobe Fuse CC](https://www.adobe.com/ch_de/products/fuse.html)  
An [Adobe ID](https://account.adobe.com/)  
Optitrack Setup for [Full body marker set](https://v20.wiki.optitrack.com/index.php?title=Skeleton_Tracking)  
Autodesk [Motion Builder](https://www.autodesk.com/products/motionbuilder/overview)  
[Unity3D](https://unity3d.com/de) or [UnrealEngine 4](https://www.unrealengine.com/en-US/what-is-unreal-engine-4)  

#### Tested with
Adobe Fuse CC (Beta)  
Motive v2.02  
Motion Builder 2018  
Unity3D 2019.1.02b  
UnrealEngine 4.21.2


#### Create Humanoid Character with Adobe Fuse
- Download Adobe Fuse. Since Fuse is still in Beta, the program has some issues starting. If double-clicking the Icon doesnt start the application, hold `Control` and hit `Enter` 10 times quickly (within 2 seconds!)
- Assemble and Customize your character as desired
- Click `Send to mixamo` This will open a browser and auto-rig the character
- Chose `Download FBX` as a Unity FBX

#### Create Optitrack animations
- Start and [configure](https://v20.wiki.optitrack.com/index.php?title=Quick_Start_Guide:_Getting_Started#Capture_Setup) Optitrack using Motive software
- Under `Create` in Motive, [define a skeleton](https://v20.wiki.optitrack.com/index.php?title=Skeleton_Tracking)(the baseline should do)
- Under `Capture`, start a Mocap Take and record the desired animation. For good practice, try to start the anmiation where the origin (Optitrack [0,0,0]) lies.
- Right-click on the take and chose `Export Tracking Data`. Chose `.fbx` as a ASCII file. Tick include the actor (equal to the name of the skeleton) and export

#### Map animation onto Fuse Character
- Start Motion Builder 2018 and follow [this tutorial video](https://youtu.be/olWE17nrbTY) mostly. If you intend to use the Character in Unity, follow [this tutorial video](https://youtu.be/XEDP5Aa9jdI) The scaling of the actor and the Optical cloud are not mandatory
- Notice that in the tutorial the `mixamorig:Hips` needs to be renamed to `Hips` so that Unity or Unreal can identify it
- In the `Merge` step, several recorded animations can be chosen at the same time!
- In case the Character is misaligned (not standing on the origin), follow [this tutorial](https://youtu.be/eaZCq3L2n5s)

#### Export for display in Unreal
- Go to character, plot the take as a CONTROL RIG  
- Click on any bone on the control rig (right side) and then go to fcurves. an fcurve should be available  
- Story > Add character animation  
- Story > Insert > Current take  
- Disable ghost (eye-symbol)  
	- Click on the actual story region (or take region)  
- Realign actor  
- Get region from story  
- Plot animation  
- Save file as .fbx ASCII

#### Export and display in Unity
- Follow this tutorial [this tutorial video](https://youtu.be/XEDP5Aa9jdI)
- The open file in Motion builder can be saved directly as .fbx ASCII (File > Save as)
- After merging the actor, also export the file in Motion builder (File > Export motion file data), creating a second .fbx ASCII 
- Both files are needed for Unity. Import the first file by drag & drop in Unity. Drag the Prefab (Blue Cube) into the scene. The Fuse actor should appear
- Create a new game object `Animation Controller` (in the video around minute 12:00 it is used). Open it with a double click and then right click > create new state (In the video its renamed to `CurrentMovement`)
- In the new state, there is a slot where a motion file can be imported. Note that the first file does have its own motion file (here called simi00x, inside the .fbx). However, this file only has 7 frames imported instead of the desired ones. Fix by:
	- Import the second .fbx file (The one with the exported motion file data)
	- Click on the blue prefab to show its content. It should contain a new motionfile (probably with the same name)
	- Move to the AnimationController and select the new file (min 12:30 in the video)



# Photogrammetry (VisualSFM)  
![Tryptich](https://i.imgur.com/5BESQZk.png) 

#### Requirements:  
[Visual SFM software](http://ccwu.me/vsfm/)  
Pictures (.jpg) of human model 
[Blender](https://www.blender.org/) or [3dsMax](https://www.autodesk.ch/de)  
An [Adobe ID](https://account.adobe.com/)  
[Unity3D](https://unity3d.com/de) or [UnrealEngine 4](https://www.unrealengine.com/en-US/what-is-unreal-engine-4)  

#### Tested with
Visual SFM v0.5.26  
3dsMax 2016  
Unity3D 2019.1.02b 
UnrealEngine 4.21.2


#### General [Workflow](https://www.youtube.com/watch?v=IStU-WP2XKs) for point cloud reconstruction
- Add images to the project (For good results, the background shouldnt be neutral. Good results are possible with 50 pictures for a human model)
- Match the pictures 
- Sparse reconstruction (Matches points which are identified by multiple cameras)
- Dense reconstruction (Interpolates the information between the sparse points, thus creating a mesh)
- Export as `.fbx` file. The file will contain a Object and several texture maps [like this example](https://imgur.com/a/GML2Wm4)

#### Isolate object
- Import the `.fbx` in either 3dsMax or Blender and [delete unwanted mesh parts](https://youtu.be/IStU-WP2XKs?t=500)
- Export the Character again as `.fbx`

#### Humanoid Rig (mixamo)
- Go to the [Mixamo Website](https://www.mixamo.com/#/)
- Select `Character` and then `Upload Character`. Chose the `.fbx` file you created. 
- To Rig the object, define the constraints of [chin, elbows, wrists, groin, and knees](https://imgur.com/a/u6TirEr). Mixamo uses an ML approach to add a skeleton into your mesh.
- Select `Download` and then chose `.fbx`. Note that Mixamo has a Unity-adjusted Fbx (Skeleton will be displayed correctly). Unfortunately, the FBX export for Unreal was stopped 2017. Yet, the sole `.fbx` can still be used with a little workaround

#### Setup and animate character with Unity
- Drag and drop the Character into the Asset folder. Download animations from Mixamo and [apply](https://www.youtube.com/watch?v=P4PrO8fHZ4E) 

#### Setup and animate character with Unreal
- From Mixamo, download the character as a regular `.fbx` in T-pose.
- Import the model in Unreal following [this tutorial](https://www.youtube.com/watch?v=WakAHtUoorI). Retarget all the textures from the model as in the video
- Open the `bodymap` texture and chose blendmode `masked` and use the white texture (eyebrows only) to work as an opacity mask! Do this to all the other maps. 
- *You should use the same skeletal asset for all of the characters so that animations can be transferred. UE provides a tool for retargeting animations to different meshes though!*  




Contact: email.daniel.ch@gmail.com



