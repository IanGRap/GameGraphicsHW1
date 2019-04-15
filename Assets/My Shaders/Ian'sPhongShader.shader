Shader "Custom/Ian'sPhongShader"
{
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
				return fixed4(1, 0, 0, 1);
			}

			ENDCG
		}
		
	}
}
