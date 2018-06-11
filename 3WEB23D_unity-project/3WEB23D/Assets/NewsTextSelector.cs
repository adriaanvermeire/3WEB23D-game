using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NewsTextSelector : MonoBehaviour {

    GameState gameState;
    public Text lostText;
    public Text wonText;

	// Use this for initialization
	void Start () {
        gameState = GameObject.Find("GameState").GetComponent<GameState>();
	}
	
	// Update is called once per frame
	void Update () {
        if (gameState.helpedGirlInBus)
        {
            wonText.gameObject.SetActive(true);
        }
        else
        {
            lostText.gameObject.SetActive(true);
        }
	}
}
