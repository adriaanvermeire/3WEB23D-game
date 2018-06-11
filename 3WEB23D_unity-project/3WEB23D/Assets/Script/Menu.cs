using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Menu : MonoBehaviour {

    public void StartGame()
    {
        SceneManager.LoadScene("Bus-scene");
    }



    public void MainMenu()
    {


        SceneManager.LoadScene("mainMenu");
    }

    public void Instructions()
    {


        SceneManager.LoadScene("instructions");
    }

    public void QuiteGame()
    {
        Application.Quit();
    }
}
