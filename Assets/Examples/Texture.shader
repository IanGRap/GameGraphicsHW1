Shader "CM163/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color1 ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"

            struct VertexShaderInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexShaderOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            VertexShaderOutput vert (VertexShaderInput v)
            {
                VertexShaderOutput o;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; 
                return o;
            }

            float4 frag (VertexShaderOutput i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
