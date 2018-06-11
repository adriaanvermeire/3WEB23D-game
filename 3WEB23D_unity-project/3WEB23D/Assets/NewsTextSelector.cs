using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NewsTextSelector : MonoBehaviour {

    GameState gameState;
    public Image lostImage;
    public Image wonImage;

	// Use this for initialization
	void Start () {
        gameState = GameObject.Find("GameState").GetComponent<GameState>();
	}
	
	// Update is called once per frame
	void Update () {
        if (gameState.helpedGirlInBus)
        {
            wonImage.gameObject.SetActive(true);
        }
        else
        {
            lostImage.gameObject.SetActive(true);
        }
	}
}
