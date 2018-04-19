using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Playables;

public class StartDialogue : MonoBehaviour {
    public static GameObject timeline;
    public GameObject dialogueUI;
    public PlayableDirector playableDirector = timeline.GetComponent<PlayableDirector>();
    public Button beginDialogueButton;

    private void Update()
    {
        if (playableDirector.state != PlayState.Playing)
        {
            dialogueUI.SetActive(false);
        }
    }

    private void OnTalkButtonClicked()
    {
        dialogueUI.SetActive(true);
        playableDirector.Play();
    }

    //check if player's collider has entered the trigger
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("object is IN dialogue trigger");
            //if the above is true set isInTrigger to true
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
            beginDialogueButton.gameObject.SetActive(false);
        }
    }
}
