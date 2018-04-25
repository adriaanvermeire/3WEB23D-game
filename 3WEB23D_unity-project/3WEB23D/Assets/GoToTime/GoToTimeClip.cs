using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class GoToTimeClip : PlayableAsset, ITimelineClipAsset
{
    public GoToTimeBehaviour template = new GoToTimeBehaviour ();

    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable (PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<GoToTimeBehaviour>.Create (graph, template);
        GoToTimeBehaviour clone = playable.GetBehaviour ();
        return playable;
    }
}
