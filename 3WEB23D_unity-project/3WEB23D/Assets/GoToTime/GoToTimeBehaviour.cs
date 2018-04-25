using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class GoToTimeBehaviour : PlayableBehaviour
{
    public double timeToSkipTo;

    private PlayableDirector director;

    public override void OnPlayableCreate (Playable playable)
    {
        director = (playable.GetGraph().GetResolver() as PlayableDirector);
    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        director.time = timeToSkipTo;
    }

}
