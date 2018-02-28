using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour {


    public float rotationSpeed = 3.5f;
    private float Y;

    // Use this for initialization
    void Start () {
        transform.rotation = Quaternion.Euler(0, 90f, 0);
    }
	
	// Update is called once per frame
	void Update () {
        if (Input.GetMouseButton(0))
        {
            transform.Rotate(new Vector3(0, -Input.GetAxis("Mouse X") * rotationSpeed, 0));
            Y = transform.rotation.eulerAngles.y;
            transform.rotation = Quaternion.Euler(0, Y, 0);
        }
	}
}
