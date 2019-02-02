# Instructions for capturing in Optitrack environment
Link to example [Video](https://youtu.be/YpsTd9Q8pAo) of this step

## Camera setup
- Mount Gopro on stative. Lens should be on approximate eye-level for the future Unity environment. Recommended lens height: 1.65m
- Tilt camera to cover the required ground area for all movement
- At the back of the Lab, add a black tape to the wall at the height of the subject. This is a reference point, whether the subject is standing or not (see start capture for implications)

## Optitrack setup
- Setup and Calibrate Optitrack through Motive Software
- Use basic Markerset for full body capture

- *Alternatively, but not scripted*
- Attach markerset of three or four markers on the highest head position of subject
- Select markers in Optitrack and add as a rigid body

## Capture setup
- For best results, the subject should wear all black clothes. White, green or reflective wearables should be taped!

## Start capture
- The participant is required to start in a crouched position. This is necessary since the Optitrack capture and the video capture will be synchronized by the event, where the subject stands up to full height.
- Press record on camera and record on Optitrack
- The subject can stand up. If the skeleton is not recognized (because of the crouching position, the subject can move after standing up to synchronize full body marker set (this step is not necessary with rigid body alternative)
- Make sure that the subject stands up in front of the black marker (in the video feed, the frame when the subject covers the marker need to be identified later)

## End capture
- In Motive, export the take as .c3d file 
- With Gopro, copy the .mp4 video to a drive