using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[Serializable]
public class DialogueChoiceBehaviour : PlayableBehaviour
{
    [HideInInspector]
    public Button firstButton;
    [HideInInspector]
    public Button secondButton;
    [HideInInspector]
    public Text firstButtonText;
    [HideInInspector]
    public Text secondButtonText;
    [HideInInspector]
    public GameState gameState;

    public bool firstButtonActive;
    public bool secondButtonActive;

    public string firstButtonString;
    public string secondButtonString;

    public double clipStartTimeSeconds;
    public double clipEndTimeSeconds;

    public double firstSkipToSeconds;
    public double secondSkipToSeconds;

    public bool firstButtonIsConsequence;
    public bool secondButtonIsConsequence;

    public string FirstButtonChoiceId;
    public string SecondButtonChoiceId;

    private PlayableDirector director;

    public override void OnPlayableCreate(Playable playable)
    {
        director = (playable.GetGraph().GetResolver() as PlayableDirector);
    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        //Debug.Log("the time is " + director.time);
        //clipEndTimeSeconds -= 0.084;
        if (firstButtonActive)
        {
            firstButton.gameObject.SetActive(true);
            firstButtonText.text = firstButtonString;
            firstButton.onClick.AddListener(OnFirstButtonClick);
        }
        if (secondButtonActive)
        {
            secondButton.gameObject.SetActive(true);
            secondButtonText.text = secondButtonString;
            secondButton.onClick.AddListener(OnSecondButtonClick);
        }
        if (director.time >= (clipEndTimeSeconds - 0.02))
        {
            director.time = clipStartTimeSeconds;
        }
    }

    public void OnFirstButtonClick()
    {
        //Debug.Log("first button clicked");
        firstButton.gameObject.SetActive(false);
        secondButton.gameObject.SetActive(false);
        director.time = firstSkipToSeconds;
        if (firstButtonIsConsequence)
        {
            gameState.SetState(FirstButtonChoiceId);
        }
    }

    public void OnSecondButtonClick()
    {
        //Debug.Log("second button clicked");
        firstButton.gameObject.SetActive(false);
        secondButton.gameObject.SetActive(false);
        director.time = secondSkipToSeconds;
        if (secondButtonIsConsequence)
        {
            gameState.SetState(SecondButtonChoiceId);
        }
    }

}