using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameState : MonoBehaviour {

    Scene currentScene;

    //---test states from the gamplay-test-scene---
    private bool choseWOW = false;
    private bool choseLolol = false;
    private int sec;
    //---end of test states---
    private bool busSceneGirlFirstChoice = false;
    private bool busSceneGirlSecondChoice = false;
    private bool busSceneManFirstChoice = false;
    private bool busSceneManSecondChoice = false;
    private bool busSceneManThirdChoice = false;

    public Image imagebackround;
    public Text lostTxt;
    public Text wonTxt;

    private bool testChapterPlaying = false;

    private byte amountOfTimeToDisplayDebug1;
    private byte amountOfTimeToDisplayDebug2;

    // Use this for initialization
    void Start()
    {
        currentScene = SceneManager.GetActiveScene();
        amountOfTimeToDisplayDebug1 = 0;
        amountOfTimeToDisplayDebug2 = 0;
        imagebackround.gameObject.SetActive(false);
        lostTxt.gameObject.SetActive(false);
        wonTxt.gameObject.SetActive(false);
        sec = 0;
    }

    // Update is called once per frame
    void Update () {
        if (currentScene.name == "gamplay-test-scene")
        {
            if (choseWOW && amountOfTimeToDisplayDebug1 == 0)
            {
                Debug.Log("You chose: wow");
                amountOfTimeToDisplayDebug1++;
            }
            if (choseLolol && amountOfTimeToDisplayDebug2 == 0)
            {
                Debug.Log("You chose: lolol");
                amountOfTimeToDisplayDebug2++;
            }
        }
        //if (currentScene.name == "Bus-scene")
        //{
        //    if (busSceneGirlFirstChoice || busSceneGirlSecondChoice || busSceneManFirstChoice || busSceneManSecondChoice || busSceneManThirdChoice)
        //    {
        //        loadSquareScene();
        //    }
        //}
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
            case "s01d01c01":
                busSceneGirlFirstChoice = true;
                Debug.Log("Girl first choice");
                sec = 7;
                StartCoroutine(waitFiveSecondsWhenLost());
                break;
            case "s01d01c02":
                busSceneGirlSecondChoice = true;
                sec = 5;
                StartCoroutine(waitFiveSecondsWhenWon());
                break;
            case "s01d01c03":
                busSceneManFirstChoice = true;
                sec = 1;
                StartCoroutine(waitFiveSecondsWhenLost());
                break;
            case "s01d01c04":
                busSceneManSecondChoice = true;
                sec = 15;
                StartCoroutine(waitFiveSecondsWhenLost());
                break;
            case "s01d01c05":
                busSceneManThirdChoice = true;
                sec = 9;
                StartCoroutine(waitFiveSecondsWhenWon());
                break;


            default:
                break;
        }
    }

    public void loadSquareScene()
    {
        SceneManager.LoadScene("square-scene");
    }

    IEnumerator waitFiveSecondsWhenLost()
    {
        print(Time.time);
        yield return new WaitForSeconds(sec);
        imagebackround.gameObject.SetActive(true);
        lostTxt.gameObject.SetActive(true);
        print(Time.time);
    }

    IEnumerator waitFiveSecondsWhenWon()
    {
        print(Time.time);
        yield return new WaitForSeconds(sec);
        imagebackround.gameObject.SetActive(true);
        wonTxt.gameObject.SetActive(true);
        print(Time.time);
    }


}
