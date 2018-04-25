using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

[CustomEditor(typeof(CharacterMovement))]
public class CharacterMovementEditor : Editor {

    private bool showWaypointEnable = false;

    public override void OnInspectorGUI()
    {
        //base.OnInspectorGUI();
        CharacterMovement characterMovement = (CharacterMovement)target;

        EditorGUILayout.LabelField("Player", EditorStyles.boldLabel);
        characterMovement.player = (GameObject)EditorGUILayout.ObjectField("player", characterMovement.player, typeof(GameObject), true);
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("Directions", EditorStyles.boldLabel);
        showWaypointEnable = EditorGUILayout.Foldout(showWaypointEnable, "Enable Directions");
        if (showWaypointEnable)
        {
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Forwards", EditorStyles.boldLabel);
            characterMovement.forwardsEnabled = EditorGUILayout.Toggle("forwards enabled", characterMovement.forwardsEnabled);
            if (characterMovement.forwardsEnabled)
            {
                characterMovement.forwardsButton = (Button)EditorGUILayout.ObjectField("forwards button", characterMovement.forwardsButton, typeof(Button), true);
                characterMovement.forwardsWaypoint = (Transform)EditorGUILayout.ObjectField("forwards waypoint", characterMovement.forwardsWaypoint, typeof(Transform), true);
            }
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Backwards", EditorStyles.boldLabel);
            characterMovement.backwardsEnabled = EditorGUILayout.Toggle("backwards enabled", characterMovement.backwardsEnabled);
            if (characterMovement.backwardsEnabled)
            {
                characterMovement.backwardsButton = (Button)EditorGUILayout.ObjectField("backwards button", characterMovement.backwardsButton, typeof(Button), true);
                characterMovement.backwardsWaypoint = (Transform)EditorGUILayout.ObjectField("backwards waypoint", characterMovement.backwardsWaypoint, typeof(Transform), true);
            }
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Right", EditorStyles.boldLabel);
            characterMovement.rightEnabled = EditorGUILayout.Toggle("right enabled", characterMovement.rightEnabled);
            if (characterMovement.rightEnabled)
            {
                characterMovement.rightButton = (Button)EditorGUILayout.ObjectField("right button", characterMovement.rightButton, typeof(Button), true);
                characterMovement.rightWaypoint = (Transform)EditorGUILayout.ObjectField("right waypoint", characterMovement.rightWaypoint, typeof(Transform), true);
            }
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Left", EditorStyles.boldLabel);
            characterMovement.leftEnabled = EditorGUILayout.Toggle("left enabled", characterMovement.leftEnabled);
            if (characterMovement.leftEnabled)
            {
                characterMovement.leftButton = (Button)EditorGUILayout.ObjectField("left button", characterMovement.leftButton, typeof(Button), true);
                characterMovement.leftWaypoint = (Transform)EditorGUILayout.ObjectField("left waypoint", characterMovement.leftWaypoint, typeof(Transform), true);
            }
        }

    }

}
