using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndingText : MonoBehaviour {

    GameState gameState;
    public Text lostText;
    public Text wonText;

    // Use this for initialization
    void Start()
    {
        gameState = GameObject.Find("GameState-2").GetComponent<GameState>();
    }

    // Update is called once per frame
    void Update()
    {
        if (gameState.helpedGirlOnSquare)
        {
            wonText.gameObject.SetActive(true);
        }
        else
        {
            lostText.gameObject.SetActive(true);
        }
    }
}
