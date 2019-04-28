using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ian_PingPong_CellularAutomata : MonoBehaviour
{
    [SerializeField]
    private Color _bornColor = Color.blue;

    [SerializeField]
    private Color _aliveColor = Color.cyan;

    [SerializeField]
    private float _aliveLerpValue = 0.05f;

    [SerializeField]
    private Color _justDiedColor = Color.white;

    [SerializeField]
    private Color _longDeadColor = Color.black;

    [SerializeField]
    private float _deadLerpValue = 0.05f;

    [SerializeField]
    private float _probabilityOfStartingAlive = 0.3f;

    [SerializeField]
    private int _framesTillUpdate = 2;

    [SerializeField]
    int width = 64;

    [SerializeField]
    int height = 64;

    Texture2D texA;
    Texture2D texB;
    Texture2D inputTex;
    Texture2D outputTex;
    RenderTexture rt1;

    Shader cellularAutomataShader;
    Shader ouputTextureShader;

    Renderer rend;
    int count = 0;

    void Start()
    {

        texA = new Texture2D(width, height, TextureFormat.RGBA32, false);
        texB = new Texture2D(width, height, TextureFormat.RGBA32, false);

        texA.filterMode = FilterMode.Point;
        texB.filterMode = FilterMode.Point;

        for (int i = 0; i < height; i++)
            for (int j = 0; j < width; j++)
                if (Random.Range(0.0f, 1.0f) < _probabilityOfStartingAlive)
                {
                    texA.SetPixel(i, j, _bornColor);
                } else {
                    texA.SetPixel(i, j, _justDiedColor);
                }

        texA.Apply(); //copy changes to the GPU


        rt1 = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
   

        rend = GetComponent<Renderer>();

        cellularAutomataShader = Shader.Find("Custom/RenderToTexture_CA");
        ouputTextureShader = Shader.Find("Custom/IanOutputTexture");

    }

   
    void Update()
    {
        //set active shader to be a shader that computes the next timestep
        //of the Cellular Automata system
        rend.material.shader = cellularAutomataShader;
      
        if (count % _framesTillUpdate == 0)
        {
            inputTex = texA;
            outputTex = texB;
        }
        else
        {
            inputTex = texB;
            outputTex = texA;
        }


        rend.material.SetTexture("_MainTex", inputTex);
        rend.material.SetColor("_BornColor", _bornColor);
        rend.material.SetColor("_AliveColor", _aliveColor);
        rend.material.SetFloat("_AliveLerpValue", _aliveLerpValue);
        rend.material.SetColor("_JustDiedColor", _justDiedColor);
        rend.material.SetColor("_LongDeadColor", _longDeadColor);
        rend.material.SetFloat("_DeadLerpValue", _deadLerpValue);

        //source, destination, material
        Graphics.Blit(inputTex, rt1, rend.material);
        Graphics.CopyTexture(rt1, outputTex);


        //set the active shader to be a regular shader that maps the current
        //output texture onto a game object
        rend.material.shader = ouputTextureShader;
        rend.material.SetTexture("_MainTex", outputTex);
       

        count++;
    }
}
