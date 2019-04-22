Shader "Custom/ColoredTexture"
{
    Properties
    {
        _Color ("Tint", Color) = (1, 0, 0, 1)
		_MainTex("Texture", 2D) = "white" {}
    }
    
	Subshader
	{
		Tags
		{
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}
		Pass
		{
			
			CGPROGRAM
			#include "unityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag
            
            uniform float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata 
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= _Color;
				return col;
			}

			ENDCG
		}
		
	}
}
