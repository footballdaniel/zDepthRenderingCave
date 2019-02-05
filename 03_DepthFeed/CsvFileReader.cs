using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.IO;

public class CsvFileReader : MonoBehaviour

    // This script reads a .csv script. In the script, each row contains the difference in z direction [mm] from the last frame (assumed 20fps)
    // User Input:      1. ObjectToBeMoved: Select the quad or plane that needs to be moved
    //                  2. csvFile: Select a csv file with frame by frame z-data 
    // Algorithm:       1. With each new gameframe: Calculate how many rows in the csv have been skipped
    //                  2. For each new frame: Calculate the sum of differences in the csv between the last frame and the current frame
    //                  3. Apply the sum of the difference to the new frame

{
	public GameObject ObjectToBeMoved; // The quad is attached to this object
	public TextAsset csvFile; // The csv file is as input in here
	string fieldInt;
	float expline = 1; // The expected line the filereader should be at time.timeSinceLevelLoad
	int explineInt = 1; // Expline rounded to integer
	int oldlineInt = 0; // line from last frame
	float sum = 0; // Sum of all float deviations from old to new integer

	// Update is called once per frame
	void Update()
	{
		expline = (float)Time.timeSinceLevelLoad / (float)0.05; // since the data is in 20 fps, get an expected value for what data line to read. This defines the expected line to read from 
		explineInt = Mathf.RoundToInt(expline); // Get that floatie into an integer

		// Call function
		UpdateEverySecond();
		oldlineInt = explineInt;	// after the update the expected line becomes the new old line
	}


	// Here the update called every 50 ms takes place:
	void UpdateEverySecond()
	{
        string[] records = csvFile.text.Split('\n'); // Read the csv data, which is separated with new lines
        
        // Initiate at each timestep
        sum = 0;

        /// Read the rows between the oldline and the expected line and sum all its content up
        for (int i = oldlineInt; i < explineInt; i++)
        {
            string[] fields = records[i].Split(','); // Split the records into fields
            sum = float.Parse(fields[0]) + sum; // Add each z-difference to the sum
        }

        ObjectToBeMoved.transform.Translate(0, 0, -1 * sum * 1.0f / 100000, Space.Self); // Moves the object
        // -1 is for the direction
        // the 100000 are composed of (A) transforming the milimeters to meter and (B) an additional 1e3 transformation for precision 

    }


} 

