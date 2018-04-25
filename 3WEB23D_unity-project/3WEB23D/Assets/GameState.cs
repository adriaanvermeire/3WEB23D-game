using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameState : MonoBehaviour {

    Scene currentScene;

    //---test states from the gamplay-test-scene---
    private bool choseWOW = false;
    private bool choseLolol = false;
    //---end of test states---


    private bool testChapterPlaying = false;

    private byte amountOfTimeToDisplyDebug1;
    private byte amountOfTimeToDisplyDebug2;

    // Use this for initialization
    void Start()
    {
        currentScene = SceneManager.GetActiveScene();
        amountOfTimeToDisplyDebug1 = 0;
        amountOfTimeToDisplyDebug2 = 0;
    }

    // Update is called once per frame
    void Update () {
        if (currentScene.name == "gamplay-test-scene")
        {
            if (choseWOW && amountOfTimeToDisplyDebug1 == 0)
            {
                Debug.Log("You chose: wow");
                amountOfTimeToDisplyDebug1++;
            }
            if (choseLolol && amountOfTimeToDisplyDebug2 == 0)
            {
                Debug.Log("You chose: lolol");
                amountOfTimeToDisplyDebug2++;
            }
        }
	}

    public void SetState(string choiceId)
    {
        switch (choiceId)
        {
            //---test case's from the gamplay-test-scene---
            case "t01c001":
                choseWOW = true;
                break;
            case "t01c002":
                choseLolol = true;
                break;
            //---end of test case's---



            default:
                break;
        }
    }

}
