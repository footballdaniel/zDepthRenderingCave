# Instructions for preparing the greenscreen video

## Import video in Premiere Pro
- Open Premiere Pro CC
- Right click the [import](https://filmora.wondershare.com/adobe-premiere/adobe-premiere-import-export.html) section and select the video  
- In the project folder, right click on the imported video and chose "create sequence from clip". A new sequence with the same name is created just below the video file ([tutorial](https://helpx.adobe.com/ch_de/premiere-pro/how-to/create-edit-sequence.html)). Rightlick and rename the sequence, then double click to open  
- [Cut](https://www.youtube.com/watch?v=YJhJuuPAzvg) video so that the video starts at the frame when the subject reaches the marker tape height after standing up  

## Apply Key for the Greenscreening effect
- Apply the "[Ultra Key](https://www.youtube.com/watch?v=p-sZyzs-fnI)" Effect to the timeline.  
- The settings for the Ultra Key can bei imported from the Preset file (.../01_Scripts/UltraKeyPreset.prfpset). The preset file can be added to the Premiere Project [the following way](https://www.youtube.com/watch?v=cV3XFTiRXt4)  
- In the "Effect Controls" window (Shift+5), the settings of the ultra Key can be adjusted. Most importantly, the settings under "Matte Generation" are of interest to mask all background  
- After the application, the background around the player should be subtracted and should yield a result like [this](https://imgur.com/1xUoAjd)  


## Crop the video to body height for each frame
- Since the video will be displayed in real size, the subject in the video has to be scaled to fit the frame size troughout the video, like [here](https://youtu.be/ze-whcJwS2A)
- Suggestion is to use [Keyframe animation](https://www.youtube.com/watch?v=GR-bEGYi8D4). The subject is scaled to fit the vertical height. Then, the position is adjusted to make the subject fit vertically in the video. The horizontal component is not changed if possible
- Note: If the recorded movements are strong in horizontal dimension (e.g. the subject walks out of the frame horizontally after scaling, the x-Component could also be rendered separately, analogously to the procedure in Chapter 03)
- After Keyframing, the subject should alwyas appear fully scaled in the frame, similar to [here](https://imgur.com/a/e7H2mB3).  

## Install WEBM plugin
- The Plugin needs to be downloaded and installed from [here](https://www.fnordware.com/WebM/). It is necessary to display the transparent background as an alpha channel in Unity5

## Export video
- With the timeline selected, press Ctrl+M to bring up export window
- On the right side, under "Format", the WebM should be accessible
- For the preset, select "import preset" and chose WebMforUnity.epr (located under .../02_Greenscreen/01_Scripts)
- Click on the blue text by "Output field" to chose where to save the video
- Export the video
