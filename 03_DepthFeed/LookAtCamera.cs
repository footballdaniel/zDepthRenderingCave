// This complete script can be attached to a camera to make it
// continuously point at another object.

// The target variable shows up as a property in the inspector.
// Drag another object onto it to make the camera look at it.
using UnityEngine;
using System.Collections;
using UnityEditor;

public class LookAtCamera : MonoBehaviour
{
    public Transform target;
    public static bool changeDirection = true;
    private float direction = 1f;



    private void Start()
    {
        // Check the bool Checkbox in the script editor
        if (changeDirection = true)
        {
            direction = 180f;
        }
    }


    void Update()
    {
        // Rotate the camera every frame so it keeps looking at the target
        transform.LookAt(target);
        transform.RotateAround(transform.position, transform.up, direction);

    }
}