using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Playables;
using UnityEngine.SceneManagement;

public class StartDialogue : MonoBehaviour {
    public GameObject player;
    public GameObject currentWaypoint;
    public GameObject dialogueUI;
    public PlayableDirector playableDirector;
    public Button beginDialogueButton;
    public Camera playerCamera;
    public bool loadSceneAfterDialogueEnd = false;
    [SerializeField]
    public string sceneName;

    private bool isInTrigger = false;
    private bool playableDirectorHasStopped = false;

    void Start()
    {
        playableDirector = playableDirector.GetComponent<PlayableDirector>();
    }

    private void Update()
    {
        if (playableDirectorHasStopped)
        {
            if (loadSceneAfterDialogueEnd)
            {
                SceneManager.LoadScene(sceneName, LoadSceneMode.Single);
            }
            else
            {
                playerCamera.gameObject.SetActive(true);
                dialogueUI.SetActive(false);
                player.GetComponent<CameraMovement>().enabled = true;
                currentWaypoint.SetActive(true);
                if (isInTrigger)
                {
                    beginDialogueButton.gameObject.SetActive(true);
                }
            }
        }
    }

    private void OnTalkButtonClicked()
    {
        dialogueUI.SetActive(true);
        playerCamera.gameObject.SetActive(false);
        player.GetComponent<CameraMovement>().enabled = false;
        currentWaypoint.SetActive(false);
        playableDirectorHasStopped = false;
        beginDialogueButton.gameObject.SetActive(false);
        playableDirector.Play();
    }

    //check if player's collider has entered the trigger
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("object is IN dialogue trigger");
            //if the above is true set isInTrigger to true
            isInTrigger = true;
            beginDialogueButton.gameObject.SetActive(true);
            beginDialogueButton.onClick.AddListener(OnTalkButtonClicked);
        }
    }

    //chek if player's collider has left the trigger
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("object LEFT dialogue trigger");
            //if the above is true set isInTrigger to false
            isInTrigger = false;
            beginDialogueButton.gameObject.SetActive(false);
        }
    }

    void OnEnable()
    {
        playableDirector.stopped += OnPlayableDirectorStopped;
    }

    void OnPlayableDirectorStopped(PlayableDirector aDirector)
    {
        if (playableDirector == aDirector)
        {
            Debug.Log("PlayableDirector named " + aDirector.name + " is now stopped.");
            playableDirectorHasStopped = true;
        }
    }

    void OnDisable()
    {
        playableDirector.stopped -= OnPlayableDirectorStopped;
    }

}
