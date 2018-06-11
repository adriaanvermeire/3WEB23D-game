using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class play : MonoBehaviour {

    int amountAccessed = 0;
	// Use this for initialization
	void Start () {
        if (amountAccessed == 0)
        {
            AudioSource audio = GetComponent<AudioSource>();
            audio.Play();
            amountAccessed++;
        }
    }

}
