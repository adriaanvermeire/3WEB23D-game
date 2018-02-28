using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.AI;

public class CharacterMovement : MonoBehaviour {

    public bool forwardsEnabled = false;
    public bool backwardsEnabled = false;
    public bool rightEnabled = false;
    public bool leftEnabled = false;

    public GameObject player;
    private NavMeshAgent playerAgent;

    public Button forwardsButton;
    public Button backwardsButton;
    public Button rightButton;
    public Button leftButton;

    public Transform forwardsWaypoint = null;
    public Transform backwardsWaypoint = null;
    public Transform rightWaypoint = null;
    public Transform leftWaypoint = null;

    private bool isInTrigger = false;

    // Use this for initialization
    void Start()
    {
        playerAgent = player.GetComponent<NavMeshAgent>();
    }


    // Update is called once per frame
    void Update()
    {
        //Debug.Log(isInTrigger);

        //check if player is in the trigger and wich button should be enabled or not
        //also check if the button is pressed if so call GoToWaypointOnClick() with the corresponding waypoint
        if (forwardsEnabled && isInTrigger)
        {
            forwardsButton.gameObject.SetActive(true);
            forwardsButton.onClick.AddListener(() => GoToWaypointOnClick(forwardsWaypoint));
            //Debug.Log("button enabled");
        }
        if (backwardsEnabled && isInTrigger)
        {
            backwardsButton.gameObject.SetActive(true);
            backwardsButton.onClick.AddListener(() => GoToWaypointOnClick(backwardsWaypoint));
            //Debug.Log("button enabled");
        }
        if (rightEnabled && isInTrigger)
        {
            rightButton.gameObject.SetActive(true);
            rightButton.onClick.AddListener(() => GoToWaypointOnClick(rightWaypoint));
            //Debug.Log("button enabled");
        }
        if (leftEnabled && isInTrigger)
        {
            leftButton.gameObject.SetActive(true);
            leftButton.onClick.AddListener(() => GoToWaypointOnClick(leftWaypoint));
            //Debug.Log("button enabled");
        }
        //end of previous check

    }

    private void GoToWaypointOnClick(Transform target)
    {
        playerAgent.SetDestination(target.position);
    }

    //check if player's collider has entered the trigger
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("object is IN trigger");
            //if the above is true set isInTrigger to true
            isInTrigger = true;
        }
    }

    //chek if player's collider has left the trigger
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("object LEFT trigger");
            //if the above is true set isInTrigger to false
            isInTrigger = false;
            forwardsButton.gameObject.SetActive(false);
            backwardsButton.gameObject.SetActive(false);
            rightButton.gameObject.SetActive(false);
            leftButton.gameObject.SetActive(false);
        }
    }
}
