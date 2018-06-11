using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSquareScene : MonoBehaviour {

	public void loadSquareScene()
    {
        SceneManager.LoadScene("square-scene");
    }
}
