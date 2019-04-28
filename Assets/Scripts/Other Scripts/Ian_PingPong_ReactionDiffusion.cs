

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ian_PingPong_ReactionDiffusion : MonoBehaviour
{
    [SerializeField]
    private Color _seedColor = Color.cyan;

    [SerializeField]
    private Color _backgroundColor = Color.white;


    Texture2D texA;
    Texture2D texB;

    Texture2D inputTex;
    Texture2D outputTex;

    RenderTexture offscreenBuffer;

    Shader reactionDiffusionShader;
    Shader ouputTextureShader;

    static int width = 200;
    static int height = 200;

    Renderer rend;
    int count = 0;

    float[,,] grid; 
    float[,,] next; 

   
    void Start()
    {
         
        texA = new Texture2D(width, height, TextureFormat.RGBAFloat, false);
        texB = new Texture2D(width, height, TextureFormat.RGBAFloat, false);

        texA.filterMode = FilterMode.Point;
        texB.filterMode = FilterMode.Point;

        int floatArraySize = width * height;
        Color[] floatArray1 = new Color[floatArraySize];
        Color[] floatArray2 = new Color[floatArraySize];

        for (int i = 0; i < floatArraySize; i++)
        {
            floatArray1[i].r = _backgroundColor.r;
            floatArray1[i].g = _backgroundColor.g;
            floatArray1[i].b = _backgroundColor.b;
            floatArray1[i].a = _backgroundColor.a;

            floatArray2[i].r = _backgroundColor.r;
            floatArray2[i].g = _backgroundColor.g;
            floatArray2[i].b = _backgroundColor.b;
            floatArray2[i].a = _backgroundColor.a;
        }

       

        //tempTex2D.SetPixels(floatArray1, 0);
        texA.SetPixels(floatArray1, 0);
        //texB.SetPixels(floatArray2, 0);


        int numSeeds = 20;

        //making circular seeds
        //reference: https://stackoverflow.com/questions/1201200/fast-algorithm-for-drawing-filled-circles
        for (int i = 0; i < numSeeds; i++)
        {
            int radius = Random.Range(5, 25);
            int centerX = Random.Range(radius, width - radius);
            int centerY = Random.Range(radius, height - radius);

            for (int x = -radius; x <= radius; x++)
            {
                for (int y = -radius; y <= radius; y++)
                {
                    if (x * x + y * y <= radius * radius)
                    {
                        texA.SetPixel(centerX + x, centerY + y, _seedColor);
                    }
                }
            }
        }

        texA.Apply(); //copies our changes made here on the CPU to the GPU so that they are made available to our shaders

        offscreenBuffer = new RenderTexture(width, height, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
        offscreenBuffer.filterMode = FilterMode.Point;

        rend = GetComponent<Renderer>();

        reactionDiffusionShader = Shader.Find("Custom/Ian_RenderToTexture_RD");
        ouputTextureShader      = Shader.Find("Custom/Ian_OutputTexture_RD");

        //print(" supports TextureFormat.RGBAFloat?  " + SystemInfo.SupportsTextureFormat(TextureFormat.RGBAFloat));
        //print(" supports RenderTextureFormat.ARGBFloat?: " + SystemInfo.SupportsTextureFormat(TextureFormat.RGBAFloat));

    }

    void Update()
    {
        if (count % 2 == 0)
        {
            inputTex = texA;
            outputTex = texB;
        }
        else
        {
            inputTex = texB;
            outputTex = texA;
        }

        //set active shader to be a shader that computes the next timestep
        //of the Cellular Automata system
        rend.material.shader = reactionDiffusionShader;

        //rend.material.SetTexture("_MainTex", inputTex); //redundant here since the Blit command assigns inputTex to the default _MainTex

        //source, destination, material (with shader bound to it)
        Graphics.Blit(inputTex, offscreenBuffer, rend.material);
        Graphics.CopyTexture(offscreenBuffer, outputTex);


        //// to copy from GPU to CPU (slow)
        //RenderTexture.active = rt1;
        //Texture2D tex = new Texture2D(rt1.width, rt1.height, TextureFormat.RGBAFloat, false);
        //tex.ReadPixels(new Rect(0, 0, rt1.width, rt1.height), 0, 0);
        //tex.Apply();
        //Color[] pixA = tex.GetPixels(1, 1, 1, 1);
        //print("pixel outputTex = " + pixA[0].r); //checking to see if output texture holds a floating point variable instead of a uint8 color val

        

        //set the active shader to be a regular shader that maps the current
        //output texture onto a game object
        rend.material.shader = ouputTextureShader;
        rend.material.SetTexture("_MainTex", outputTex);


        count++;

    }
}
