using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour {


    public float rotationSpeed = 3.5f;
    public float rotationSpeedAndriod = 0.1f;
    public float startRotation = 0;
    private float Y;
    private float pointer_x;

    // Use this for initialization
    void Start () {
        transform.rotation = Quaternion.Euler(0, startRotation, 0);
        pointer_x = Input.GetAxis("Mouse X");
    }
	
	// Update is called once per frame
	void Update () {
        if (SystemInfo.deviceType == DeviceType.Desktop)
        {
            if (Input.GetMouseButton(0))
            {
                pointer_x = Input.mousePosition[0];
                transform.Rotate(new Vector3(0, -Input.GetAxis("Mouse X") * rotationSpeed, 0));
                Y = transform.rotation.eulerAngles.y;
                transform.rotation = Quaternion.Euler(0, Y, 0);
            }
        }
        if (SystemInfo.deviceType == DeviceType.Handheld)
        {
            if (Input.touchCount == 2)
            {
                pointer_x = Input.touches[0].deltaPosition.x;
                transform.Rotate(new Vector3(0, -pointer_x * rotationSpeedAndriod, 0));
                Y = transform.rotation.eulerAngles.y;
                transform.rotation = Quaternion.Euler(0, Y, 0);
            }
        }
	}
}
