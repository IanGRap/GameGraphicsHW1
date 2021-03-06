﻿Shader "Custom/SolidColor"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
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

			struct appdata 
			{
				float4 vertex : POSITION;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f o) : SV_Target
			{
				return _Color;
			}

			ENDCG
		}
		
	}
}
