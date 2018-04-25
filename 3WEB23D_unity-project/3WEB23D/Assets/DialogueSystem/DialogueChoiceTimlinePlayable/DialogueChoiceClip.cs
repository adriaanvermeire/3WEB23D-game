using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[Serializable]
public class DialogueChoiceClip : PlayableAsset, ITimelineClipAsset {
    public DialogueChoiceBehaviour template = new DialogueChoiceBehaviour();
    public ExposedReference<Button> firstButton;
    public ExposedReference<Button> secondButton;
    public ExposedReference<Text> firstButtonText;
    public ExposedReference<Text> secondButtonText;
    public ExposedReference<GameObject> gameStateGameObject;
    private GameState gameState;
    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<DialogueChoiceBehaviour>.Create(graph, template);
        DialogueChoiceBehaviour clone = playable.GetBehaviour();
        clone.firstButton = firstButton.Resolve(graph.GetResolver());
        clone.secondButton = secondButton.Resolve(graph.GetResolver());
        clone.firstButtonText = firstButtonText.Resolve(graph.GetResolver());
        clone.secondButtonText = secondButtonText.Resolve(graph.GetResolver());
        clone.gameState = gameStateGameObject.Resolve(graph.GetResolver()).GetComponent<GameState>();
        return playable;
    }
}
