using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlurWithMousePosition : MonoBehaviour
{
    public float leftXPosition;
    public float rightXPosition;

    public float lowBlur;
    public float highBlur;

    private Material material;

    private void Awake()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        var input = Mathf.Max(Mathf.Min(Input.mousePosition.x, rightXPosition), leftXPosition);

        var value = (input - leftXPosition) / (rightXPosition - leftXPosition);

        var blur = value * (highBlur - lowBlur);

        material.SetFloat("_Blur", blur);
    }
}
